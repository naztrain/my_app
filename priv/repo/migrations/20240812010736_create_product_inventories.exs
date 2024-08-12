defmodule MyApp.Repo.Migrations.CreateProductInventories do
  use Ecto.Migration

  def change do
    create table(:product_inventories) do
      add :quantity_reserved, :integer, default: 0
      add :quantity_onhand, :integer, default: 0
      add :product_id, references(:products, on_delete: :restrict)

      timestamps()
    end

    create index(:product_inventories, [:product_id])
  end
end
