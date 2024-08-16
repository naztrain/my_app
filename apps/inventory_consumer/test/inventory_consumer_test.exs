defmodule InventoryConsumerTest do
  use ExUnit.Case
  doctest InventoryConsumer

  test "greets the world" do
    assert InventoryConsumer.hello() == :world
  end
end
