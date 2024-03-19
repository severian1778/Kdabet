import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :authentication_bridge, AuthenticationBridge.Repo1,
  database: "repo1_test",
  hostname: "localhost",
  username: "postgres",
  password: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

config :authentication_bridge, AuthenticationBridge.Repo2,
  database: "repo2_test",
  hostname: "localhost",
  username: "postgres",
  password: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

config :authentication_bridge, AuthenticationBridge.Repo3,
  database: "repo3_test",
  hostname: "localhost",
  username: "postgres",
  password: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :authentication_bridge, AuthenticationBridgeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "OPAsh2w0kglGgCRenOfI8VxSGSlR1IxcXlIUM80xlD/+kCfzMR633eie5/K5Var/",
  server: false

# In test we don't send emails.
config :authentication_bridge, AuthenticationBridge.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
