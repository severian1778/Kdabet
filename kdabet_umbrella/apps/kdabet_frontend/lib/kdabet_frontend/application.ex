defmodule KdabetFrontend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      KdabetFrontendWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: KdabetFrontend.PubSub},
      # Start Finch
      {Finch, name: KdabetFrontend.Finch},
      # Start the Endpoint (http/https)
      KdabetFrontendWeb.Endpoint,
      %{
        id: KdabetFrontend.Kings.Cache,
        start: {KdabetFrontend.Kings.Cache, :start_link, []}
      },
      # {KdabetFrontend.Worker, arg}
      {KdabetFrontend.Kings, %{opts: [name: KdabetFrontend.Kings]}},
      KdabetFrontend.Repo 
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KdabetFrontend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KdabetFrontendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
