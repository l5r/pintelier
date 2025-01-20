defmodule Pintelier.Repo do
  use Ecto.Repo,
    otp_app: :pintelier,
    adapter: Ecto.Adapters.Postgres
end
