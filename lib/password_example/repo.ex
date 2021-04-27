defmodule PasswordExample.Repo do
  use Ecto.Repo,
    otp_app: :password_example,
    adapter: Ecto.Adapters.Postgres
end
