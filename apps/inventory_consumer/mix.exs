defmodule InventoryConsumer.MixProject do
  use Mix.Project

  def project do
    [
      app: :inventory_consumer,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :shared],
      mod: {InventoryConsumer.Application, []}

    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:broadway_kafka, "~> 0.3"},
      {:ecto_sql, "~> 3.2"},
      {:postgrex, "~> 0.15"},
      {:shared, in_umbrella: true}
    ]
  end
end
