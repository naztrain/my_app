# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Repo for InventoryConsumer
config :shared, Shared.Repo,
  database: "elevate",
  username: "elevate",
  password: "elevate",
  hostname: "localhost",
  pool_size: 10,
  adapter: Ecto.Adapters.Postgres

config :shared, ecto_repos: [Shared.Repo]

config :logger, level: :info
