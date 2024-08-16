defmodule OrderProducerTest do
  use ExUnit.Case
  doctest OrderProducer

  test "greets the world" do
    assert OrderProducer.hello() == :world
  end
end
