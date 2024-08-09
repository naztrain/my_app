import Config

config :my_app, MyApp.Repo,
  database: "Ecom319",
  username: "elevate",
  password: "elevate",
  hostname: "localhost"

config :my_app,
  ecto_repos: [MyApp.Repo]
