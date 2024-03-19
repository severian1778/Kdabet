defmodule AuthenticationBridge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AuthenticationBridgeWeb.Telemetry,
      # AuthenticationBridge.Repo1,
      # AuthenticationBridge.Repo2,
      # AuthenticationBridge.Repo3,
      {DynamicSupervisor, strategy: :one_for_one, name: AuthenticationBridge.DynamicSupervisor},
      {DNSCluster,
       query: Application.get_env(:authentication_bridge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AuthenticationBridge.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AuthenticationBridge.Finch},
      # Start a worker by calling: AuthenticationBridge.Worker.start_link(arg)
      # {AuthenticationBridge.Worker, arg},
      # Start to serve requests, typically the last entry
      {AuthenticationBridgeWeb.Endpoint, name: AuthenticationBridgeWeb.Endpoint}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuthenticationBridge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuthenticationBridgeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
