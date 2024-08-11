defmodule MyApp.SalesOrderLineItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales_order_line_items" do
    field :quantity, :integer
    field :subtotal, :decimal
    belongs_to :shopping_order, MyApp.SalesOrder
    belongs_to :product, MyApp.Product

    timestamps()
  end

  @doc false
  def changeset(sales_order_line_item, attrs) do
    sales_order_line_item
    |> cast(attrs, [:shopping_order_id, :product_id, :quantity, :subtotal])
    |> validate_required([:shopping_order_id, :product_id, :quantity, :subtotal])
  end
end
