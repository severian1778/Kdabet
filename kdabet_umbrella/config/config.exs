# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

################################################
## CONFIGURE THE CORE REPOSITORIES
################################################
config :core, ecto_repos: [Core.Repo]

config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  database: "core_repo",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 30

################################################
## CONFIGURE TESLA CLIENT
################################################
################################################
## ENDPOINTS
################################################
config :kdabet_frontend, KdabetFrontendWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 4000],
  check_origin: ["localhost:4000", "http://70.79.233.233:4000"],
  # http: [port: 80],
  # check_origin: ["http://ec2-34-217-76-52.us-west-2.compute.amazonaws.com:80","http://kdabet.com"],
  secret_key_base: "nigpH25KTvHLMJCbeQx/MZEf0xqsNKyRTLf62H10vLKnwacFrPdVibNhVVHf1pMb",
  render_errors: [view: KdabetFrontendWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: KdabetFrontend.PubSub,
  live_view: [signing_salt: "J6ieBnWL"],
  server: true

config :logger, level: :debug

###############################################
## FRONT END CONFIG
###############################################

## ESBUILD
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/frontend/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

## TAILWIND
config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
    --config=tailwind.config.js
    --input=../priv/static/assets/app.css.tailwind
    --output=../priv/static/assets/app.css
  ),
    cd: Path.expand("../apps/frontend/assets", __DIR__)
  ]

## DART SASS
config :dart_sass,
  version: "1.61.0",
  default: [
    args: ~w(css/app.scss ../priv/static/assets/app.css.tailwind),
    cd: Path.expand("../apps/frontend/assets", __DIR__)
  ]

config :ex_fontawesome, type: "regular"
# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#
#
config :phoenix, :json_library, Jason
