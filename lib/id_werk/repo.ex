defmodule IdWerk.Repo do
  use Ecto.Repo,
    otp_app: :id_werk,
    adapter: Ecto.Adapters.Postgres
end
