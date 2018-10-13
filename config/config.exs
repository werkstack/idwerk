# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :id_werk,
  ecto_repos: [IdWerk.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :id_werk, IdWerkWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KGlfLkkLHUoSZANjvrxojjFTyULXPSG2ODj3iVBy7ttVXmsYzvRrpSFhpiRMA1EG",
  render_errors: [view: IdWerkWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: IdWerk.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason
config :ecto, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
