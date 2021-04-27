# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :password_example,
  ecto_repos: [PasswordExample.Repo]

# Configures the endpoint
config :password_example, PasswordExampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "J/pEACAFkK4DyboalEesdstORrhfGGBnEw1HskRKzZ47B7F42sDzLlT2LHZ7kq3L",
  render_errors: [view: PasswordExampleWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PasswordExample.PubSub,
  live_view: [signing_salt: "yVDZ3Lpv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
