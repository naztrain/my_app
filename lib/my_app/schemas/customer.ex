defmodule MyApp.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "customers" do
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
  end
end
