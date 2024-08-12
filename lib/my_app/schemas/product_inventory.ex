defmodule MyApp.ProductInventory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "product_inventories" do
    field :quantity_reserved, :integer
    field :quantity_onhand, :integer
    belongs_to :product, MyApp.Product

    timestamps()
  end

  @doc false
  def changeset(product_inventory, attrs) do
    product_inventory
    |> cast(attrs, [:quantity_reserved, :quantity_onhand, :product_id])
    |> validate_required([:quantity_reserved, :quantity_onhand, :product_id])
    |> validate_number(:quantity_reserved, greater_than_or_equal_to: 0)
    |> validate_number(:quantity_onhand, greater_than_or_equal_to: 0)
  end
end
