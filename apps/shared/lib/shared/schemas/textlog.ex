defmodule Shared.Textlog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "textlog" do
    field :text, :string
  end

  @doc false
  def changeset(textlog, attrs) do
    textlog
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
