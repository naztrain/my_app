defmodule Shared.Repo.Migrations.CreateTextlog do
  use Ecto.Migration

  def change do
    create table(:textlog) do
      add :text, :string
    end
  end
end
