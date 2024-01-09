defmodule Crashgame.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Crashgame.Worker.start_link(arg)
      # {Crashgame.Worker, arg}
      # {KdabetFrontend.Worker, arg}
      # {Phoenix.PubSub, name: GameServer.PubSub},
      {Phoenix.PubSub, name: :gaming_pubsub},
      {GameServer, %{opts: [name: GameServer]}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Crashgame.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
