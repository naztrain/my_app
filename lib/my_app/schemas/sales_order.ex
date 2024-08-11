defmodule MyApp.SalesOrder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales_orders" do
    field :date, :naive_datetime
    belongs_to :customer, MyApp.Customer

    timestamps()
  end

  @doc false
  def changeset(sales_order, attrs) do
    sales_order
    |> cast(attrs, [:customer_id, :date])
    |> validate_required([:customer_id, :date])
  end
end
