use Mix.Config

config :core, Core.Repo,
  database: "core_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  # show_sensitive_data_on_connection_error: true,
  pool_size: 10
