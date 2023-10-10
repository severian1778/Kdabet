## import Config 
use Mix.Config

config :core,
  ecto_repos: [Core.Repo],
  namesspace: Core

config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  database: "core_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

import_config "#{Mix.env()}.exs"
