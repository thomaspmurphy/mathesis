defmodule Mathesis.Repo do
  use Ecto.Repo,
    otp_app: :mathesis,
    adapter: Ecto.Adapters.Postgres
end
