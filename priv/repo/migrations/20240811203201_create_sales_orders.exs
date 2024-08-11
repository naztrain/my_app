defmodule MyApp.Repo.Migrations.CreateSalesOrders do
  use Ecto.Migration

  def change do
    create table(:sales_orders) do
      add :customer_id, references(:customers, on_delete: :nothing)
      add :date, :naive_datetime

      timestamps()
    end

    create index(:sales_orders, [:customer_id])
  end
end
