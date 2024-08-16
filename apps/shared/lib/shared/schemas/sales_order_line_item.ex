defmodule Shared.SalesOrderLineItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales_order_line_items" do
    field :quantity, :integer
    field :subtotal, :decimal
    belongs_to :sales_order, Shared.SalesOrder
    belongs_to :product, Shared.Product

    timestamps()
  end

  @doc false
  def changeset(sales_order_line_item, attrs) do
    sales_order_line_item
    |> cast(attrs, [:sales_order_id, :product_id, :quantity, :subtotal])
    |> validate_required([:sales_order_id, :product_id, :quantity, :subtotal])
  end
end
