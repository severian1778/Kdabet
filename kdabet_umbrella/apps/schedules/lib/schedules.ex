defmodule Schedules do
  @docmodule """

  Schedules is the general core library for calling down schedule data
  from the processes on the dynamic supervisor.  Because each worker
  is somewhat unique in its method to acquire schedule data,  there is
  no real general worker that can be spawned to handle each case.

  These convience functions perform one step tasks to manufacture key
  schedule data structures for consumption.
  """

  @registry :schedule_registry
  alias Schedules.Mlb.{Official}

  @doc """
  Fetches the current state from the Official MLB League data api
  iex(1)> get_official_mlb_data()
          return:  [%Schedule.MLB{...}, ...]
  """
  @spec get_official_mlb_data() :: map()
  def get_official_mlb_data() do
    ## fetch the pid
    [{pid, _}] = Registry.lookup(@registry, "mlbofficial")
    ## call the game state
    Official.get_state(pid)
  end
end
