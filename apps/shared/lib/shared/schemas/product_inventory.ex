defmodule Shared.ProductInventory do
  use Ecto.Schema
  import Ecto.Changeset
  alias Shared.Repo
  require Logger


  schema "product_inventories" do
    field :quantity_reserved, :integer
    field :quantity_onhand, :integer
    belongs_to :product, Shared.Product

    timestamps()
  end

  @doc false
  def changeset(product_inventory, attrs) do
    product_inventory
    |> cast(attrs, [:quantity_reserved, :quantity_onhand, :product_id])
    |> validate_required([:quantity_reserved, :quantity_onhand, :product_id])
    |> validate_number(:quantity_reserved, greater_than_or_equal_to: 0)
    |> validate_number(:quantity_onhand, greater_than_or_equal_to: 0)
    |> validate_inventory_logic()
  end

  defp validate_inventory_logic(changeset) do
    new_quantity_reserved = get_field(changeset, :quantity_reserved) || 0
    new_quantity_onhand = get_field(changeset, :quantity_onhand) || 0
    current_quantity_onhand = changeset.data.quantity_onhand
    current_quantity_reserved = changeset.data.quantity_reserved

    if (new_quantity_reserved + new_quantity_onhand) < (current_quantity_onhand + current_quantity_reserved) do
      add_error(changeset, :quantity_reserved, "Cannot reduce the total stock quantity") #this is naiive because at some point someone has to reduce the "reserved" stock
    else
      changeset
    end
  end


  def update_inventory_quantities(product_inventory, quantity_sold) when quantity_sold >= 0 do
    Repo.transaction(fn ->
      updated_inventory =
        product_inventory
        |> changeset(%{
          quantity_reserved: product_inventory.quantity_reserved + quantity_sold,
          quantity_onhand: product_inventory.quantity_onhand - quantity_sold
        })
        |> Repo.update()

      case updated_inventory do
        {:ok, _} ->
          Logger.info("Successfully updated inventory for product_id #{product_inventory.product_id}")
          :ok
        {:error, changeset} ->
          Logger.metadata(updated_inventory)
          Logger.error("Failed to update inventory for product_id #{product_inventory.product_id}")
          Repo.rollback(changeset)
          :error

      end
    end)
  end

end
