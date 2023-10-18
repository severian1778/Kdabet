defmodule Odds.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec, warn: false

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Odds.Worker.start_link(arg)
      # {Odds.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Odds.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
