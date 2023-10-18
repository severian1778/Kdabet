defmodule Odds.ScheduleSupervisor do
  use DynamicSupervisor
  ## import Schedules.{ScheduleWorker}

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_work() do
    params = [
      %{
        url: "http://pinnacle.ca"
      }
    ]

    ## start up all of the wallaby site instances
    supervise_worker_server(params)

    :ok
  end

  def init(:ok) do
    ## run a delayed task
    Task.start(fn ->
      Process.sleep(1_000)
      start_work()
    end)

    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp supervise_worker_server(params) do
    Enum.each(params, fn server ->
      opts = %{
        opts: [name: via_tuple(server.league, server.source)]
      }

      DynamicSupervisor.start_child(__MODULE__, {server.api, opts})
    end)
  end

  defp via_tuple(league, source) do
    {:via, Registry, {:schedule_registry, league <> source}}
  end
end
