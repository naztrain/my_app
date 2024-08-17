defmodule InventoryConsumer.ConsumerService do
  use Broadway
  import Ecto.Query
  require Logger

  alias Broadway.Message
  alias Shared.Repo
  alias Shared.SalesOrderLineItem
  alias Shared.ProductInventory


  def start_link(_opts) do

    Logger.info("Starting Inventory Consumer")

    topic = "InventoryUpdated"
    client_id = :inventory_producer
    hosts = [localhost: 9092]

    #:ok = :brod.start_client(hosts, client_id, _client_config=[])
    #:ok = :brod.start_producer(client_id, topic, _producer_config = [])
    :ok = :brod.start_client(hosts, client_id, _client_config=[])
    :ok = :brod.start_producer(client_id, topic, _producer_config = [])


    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           [
             hosts: [localhost: 9092],
             group_id: "group_1",
             topics: ["OrderCreated"]
           ]},
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 10
        ]
      ],
      batchers: [
        default: [
          batch_size: 100,
          batch_timeout: 200,
          concurrency: 10
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message, _) do
    Logger.info("Handle incoming order message from Kafka")
    sales_order_id = String.to_integer(message.data)
    update_inventory_for_sales_order(sales_order_id)
    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    messages
  end




  def update_inventory_for_sales_order(sales_order_id) do
    Logger.info("Updating inventory for sales order ##{sales_order_id}")
    sales_order_id
    |> get_sales_order_line_items()
    |> Enum.each(&process_line_item/1)
  end

  defp get_sales_order_line_items(sales_order_id) do
    line_items =
      from(s in SalesOrderLineItem,
        where: s.sales_order_id == ^sales_order_id
      )
      |> Repo.all()
    line_items
  end


  # Function to process each line item and update the associated product inventory
  defp process_line_item(%SalesOrderLineItem{product_id: product_id, quantity: quantity}) do
    Logger.info("Processing sales order line item for product ##{product_id}")
    product_inventory = Repo.get_by!(ProductInventory, product_id: product_id)
    # Update the product inventory
    result = Shared.ProductInventory.update_inventory_quantities(product_inventory, quantity)

    if result == {:ok, :ok} do
      generate_kafka_inventory_event(product_inventory.id)
    end
  end


  defp generate_kafka_inventory_event(product_inventory_id) do
    Logger.info("Sending kafka inventory event with product inventory id ##{product_inventory_id}")

    topic = "InventoryUpdated"
    client_id = :inventory_producer
    partition = 0

    :ok = :brod.produce_sync(client_id, topic, partition, _key="", "#{product_inventory_id}")
  end
end
