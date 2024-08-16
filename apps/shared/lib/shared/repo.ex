defmodule Shared.Repo do
  use Ecto.Repo,
    otp_app: :shared,
    adapter: Ecto.Adapters.Postgres,
    database: "elevate",
    username: "elevate",
    password: "elevate",
    hostname: "localhost"
end
