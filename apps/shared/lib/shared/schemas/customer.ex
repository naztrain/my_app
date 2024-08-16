defmodule Shared.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Shared.Repo

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


  def validate_customer_exists(customer_id) do
    query = from(c in Shared.Customer, where: c.id == ^customer_id)
    result = Repo.exists?(query)
    IO.inspect(result)
    result
  end
end
