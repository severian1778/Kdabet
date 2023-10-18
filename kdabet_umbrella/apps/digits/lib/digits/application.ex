defmodule Digits.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    #children = [
      # Starts a worker by calling: Digits.Worker.start_link(arg)
      # {Digits.Worker, arg}
    #]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    Digits.Supervisor.start_link(name: Digits.Supervisor)
  end
end
