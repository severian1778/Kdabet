import Config

## configure repos
#config :fcore, ecto_repos: [FCore.Repo]
#config :btctimesapi, ecto_repos: [FCore.Repo]

# Core Database 
#config :fcore, FCore.Repo,
#  username: "postgres",
#  password: "postgres",
#  database: "fcore",
#  hostname: "localhost",
#  show_sensitive_data_on_connection_error: true,
#  pool_size: 30

## production level configurations
# if config_env() == :prod do
config :phoenix, :json_library, Jason

# Configures the endpoint
config :kdabet_frontend, KdabetFrontendWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 4000],
  check_origin: ["http://localhost:4000", "http://70.79.233.233:4000"],
  secret_key_base: "nigpH25KTvHLMJCbeQx/MZEf0xqsNKyRTLf62H10vLKnwacFrPdVibNhVVHf1pMb",
  render_errors: [view: KdabetFrontendWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: KdabetFrontend.PubSub,
  live_view: [signing_salt: "d1QLGl8I"],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

# end
