import Config

config :my_app, MyApp.Repo,
  database: "elevate",
  username: "elevate",
  password: "elevate",
  hostname: "localhost"

config :my_app,
  ecto_repos: [MyApp.Repo]
