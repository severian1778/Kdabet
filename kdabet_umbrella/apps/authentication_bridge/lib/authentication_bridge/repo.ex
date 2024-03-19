defmodule AuthenticationBridge.Repo1 do
  use Ecto.Repo,
    otp_app: :authentication_bridge,
    adapter: Ecto.Adapters.Postgres
end

defmodule AuthenticationBridge.Repo2 do
  use Ecto.Repo,
    otp_app: :authentication_bridge,
    adapter: Ecto.Adapters.Postgres
end

defmodule AuthenticationBridge.Repo3 do
  use Ecto.Repo,
    otp_app: :authentication_bridge,
    adapter: Ecto.Adapters.Postgres
end
