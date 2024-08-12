defmodule MyApp.Repo.Migrations.CreateSalesOrderLineItems do
  use Ecto.Migration

  def change do
    create table(:sales_order_line_items) do
      add :quantity, :integer
      add :subtotal, :decimal, precision: 10, scale: 2
      add :shopping_order_id, references(:sales_orders, on_delete: :restrict)
      add :product_id, references(:products, on_delete: :restrict)

      timestamps()
    end

    create index(:sales_order_line_items, [:shopping_order_id])
    create index(:sales_order_line_items, [:product_id])
  end
end
