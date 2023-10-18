defmodule Odds.Supervisor do
  use Supervisor

  @registry :odds_registry

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Odds.OddsSupervisor, name: Odds.DynamicSupervisor},
      {Registry, keys: :unique, name: @registry}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
