use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :id_werk, IdWerkWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :id_werk, IdWerk.Repo,
  username: "postgres",
  password: "postgres",
  database: "id_werk_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :argon2_elixir, t_cost: 1, m_cost: 8

config :id_werk, IdWerk.JWT.SignatureAlgorithm,
  source: :string,
  private_key:
    "-----BEGIN EC PRIVATE KEY-----\nMHcCAQEEIGrAIJcVpJSsdCS5YO0NfA8mmJeBWt2fdzbMPxvNNml2oAoGCCqGSM49\nAwEHoUQDQgAELfKeoQQGPM4/4wxh0WOgP7tXoJrPTrSQSIMKI6pAYU68ZP3ONI1I\nVW83OtgmEVPLt+kxIHooeHVxz90jKeuaVw==\n-----END EC PRIVATE KEY-----"
