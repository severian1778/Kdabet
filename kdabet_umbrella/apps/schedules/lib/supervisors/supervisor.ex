defmodule Schedules.Supervisor do
  use Supervisor

  @registry :schedule_registry

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Schedules.ScheduleSupervisor, name: Schedules.DynamicSupervisor},
      {Registry, keys: :unique, name: @registry}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
