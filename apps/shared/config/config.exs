import Config

config :shared, Shared.Repo,
  database: "elevate",
  username: "elevate",
  password: "elevate",
  hostname: "localhost",
  pool_size: 10,
  adapter: Ecto.Adapters.Postgres

config :shared, ecto_repos: [Shared.Repo]
