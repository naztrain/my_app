import Config

config :my_app, MyApp.Repo,
  database: "elevate",
  username: "elevate",
  password: "elevate",
  hostname: "localhost",
  pool_size: 10,
  adapter: Ecto.Adapters.Postgres

config :my_app,
  ecto_repos: [MyApp.Repo]
