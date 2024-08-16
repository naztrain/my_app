defmodule Shared do
  import Ecto.Query
  alias Shared.Repo
  alias Shared.ProductInventory
  require Logger

  #modify the stock values across all products. This would never be a production function
  def restock(increment) do
    query = from(p in ProductInventory)
    Repo.update_all(query, inc: [quantity_onhand: increment])
    Logger.info("Restocked #{increment} on all products.")
  end
end
