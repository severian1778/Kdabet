defmodule Schedules do
  @moduledoc """
  Schedules is the general core library for calling down schedule data
  from the processes on the dynamic supervisor.  Because each worker
  is somewhat unique in its method to acquire schedule data,  there is
  no real general worker that can be spawned to handle each case.

  These convience functions perform one step tasks to manufacture key
  schedule data structures for consumption.
  """

  @registry :schedule_registry

  @doc """
  Fetches the current state from the Official MLB League data api
  iex(1)> get_official_mlb_data()
          return:  [%Schedule.Nba{...}, ...]
  """
  @spec get_official_mlb_data() :: map()
  def get_official_mlb_data() do
    ## fetch the pid
    [{pid, _}] = Registry.lookup(@registry, "mlbofficial")
    ## call the game state
    Schedules.Mlb.Official.get_state(pid)
  end

  @doc """
  Fetches the current state from the Official NBA League data api
  iex(1)> get_official_nba_data()
          return:  [%Schedule.NBA{...}, ...]
  """
  @spec get_official_nba_data() :: map()
  def get_official_nba_data() do
    ## fetch the pid
    [{pid, _}] = Registry.lookup(@registry, "nbaofficial")
    ## call the game state
    Schedules.Nba.Official.get_state(pid)
  end

  @doc """
  Fetches the current state from the Official NBA League data api
  iex(1)> get_official_nhl_data()
          return:  [%Schedule.NHL{...}, ...]
  """
  @spec get_official_nhl_data() :: map()
  def get_official_nhl_data() do
    ## fetch the pid
    [{pid, _}] = Registry.lookup(@registry, "nhlofficial")
    ## call the game state
    Schedules.Nhl.Official.get_state(pid)
  end

  @doc """
  Fetches the current state from the Official NBA League data api
  iex(1)> get_espn_nfl_data()
          return:  [%Schedule.NFL{...}, ...]
  """
  @spec get_espn_nfl_data() :: map()
  def get_espn_nfl_data() do
    ## fetch the pid
    [{pid, _}] = Registry.lookup(@registry, "nflespn")
    ## call the game state
    Schedules.Nfl.Espn.get_state(pid)
  end
end
