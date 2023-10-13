defmodule Schedules.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec, warn: false

  @impl true
  def start(_type, _args) do
    #children = [
      # Starts a worker by calling: Mlbschedule.Worker.start_link(arg)
      # {Mlbschedule.Worker, arg}
    #]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    Schedules.Supervisor.start_link(name: Schedules.Supervisor)
  end
end
