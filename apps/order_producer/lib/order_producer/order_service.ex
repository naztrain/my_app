defmodule OrderProducer.OrderService do
  require Logger
  alias Shared.Repo
  alias Shared.Customer
  alias Shared.ProductInventory
  alias Shared.SalesOrderLineItem
  alias Shared.SalesOrder
  use Ecto.Schema


  def start_link(_opts) do
    Logger.info("Starting Broadway Producer")
  end

  def create_sales_order(customer_id, product_quantities) do
    valid_quantities? = validate_quantities(product_quantities)
    if(!valid_quantities?) do
      Logger.warn("Creating sales order failed. All quantities should be above 0")
    else
      if(Customer.validate_customer_exists(customer_id) and valid_quantities?) do
        Logger.info("Creating sales order for customer ##{customer_id}")
        result =
          Repo.transaction(fn ->

            with :ok <- validate_inventory(product_quantities) do
              add_sales_order_and_line_items_to_db(customer_id, product_quantities)
            else
              {:error, message} ->
                Logger.warn(message)
                Repo.rollback(message)
            end
          end)
        # Now handle the result of the transaction:
        case result do
          {:ok, {:ok, sales_order_id}} ->
            send_order_to_kafka(sales_order_id)
          {:error, _reason} ->
            Logger.warn("Unable to place this order.")
        end
      else
        Logger.warn("Creating sales order failed. Customer ##{customer_id} does not exist.")
      end
    end
  end

  defp validate_quantities(product_quantities) do
    Enum.all?(product_quantities, fn {_product_id, quantity} ->
      quantity > 0
    end)
  end

  defp add_sales_order_and_line_items_to_db(customer_id, product_quantities) do
    # Create the SalesOrder record
    sales_order_changeset =
      SalesOrder.changeset(%SalesOrder{}, %{customer_id: customer_id, date: NaiveDateTime.utc_now()})

    case Repo.insert(sales_order_changeset) do
      {:ok, sales_order} ->
        Logger.info("SalesOrder created with id ##{sales_order.id}")
        # Create SalesOrderLineItem records for each product_id and quantity
        product_quantities
        |> Enum.each(fn {product_id, quantity} ->
          sales_order_line_item_changeset =
            SalesOrderLineItem.changeset(%SalesOrderLineItem{}, %{
              product_id: product_id,
              quantity: quantity,
              sales_order_id: sales_order.id,
              subtotal: 3.19
            })
          Repo.insert!(sales_order_line_item_changeset)
        end)

        {:ok, sales_order.id}

      {:error, changeset} ->
        Logger.error("Creating sales order failed. Transaction will roll back.")
        Repo.rollback(changeset)
    end
  end


  defp validate_inventory(product_quantities) do
    # Check if the product_quantities list is empty
    if product_quantities == [] do
      {:error, "No products provided"}
    else
      product_quantities
      |> Enum.reduce_while(:ok, fn {product_id, requested_quantity}, _acc ->
        case Repo.get(ProductInventory, product_id) do
          nil ->
            {:halt, {:error, "Product with ID #{product_id} not found"}}
          %ProductInventory{quantity_onhand: quantity_onhand} when quantity_onhand < requested_quantity ->
            {:halt, {:error, "Insufficient inventory for product ID #{product_id}. Available: #{quantity_onhand}, Requested: #{requested_quantity}"}}
          _ ->
            {:cont, :ok}
        end
      end)
    end
  end


  defp send_order_to_kafka(sales_order_id) do
    Logger.info("Sending order data to kafka for sales order ##{sales_order_id}")

    topic = "OrderCreated"
    client_id = :order_producer
    hosts = [localhost: 9092]
    partition = 0

    :ok = :brod.start_client(hosts, client_id, _client_config=[])
    :ok = :brod.start_producer(client_id, topic, _producer_config = [])

    :ok = :brod.produce_sync(client_id, topic, partition, _key="", "#{sales_order_id}")

    #shut down brod in this module because if we hit it with a lot of requests, we need to reclaim resources.
    #Rethinking this, the order_producer should probably be an actual running app instead of a partitioned collection of functions.
    :ok = :brod.stop_client(client_id)
  end

end
