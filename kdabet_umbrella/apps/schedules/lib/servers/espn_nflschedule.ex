defmodule Schedules.Nfl.Espn do
  use GenServer
  alias Schedules.NflEspnClient

  # alias Core.Common.Nhl
  #############################
  # Client API
  #############################
  #############################

  @moduledoc """
  Espn NflSchedule pipes the game status directly from Nfl ESPN Schedule API.
  """
  def start_link(opts) do
    options = Map.get(opts, :opts)
    GenServer.start_link(__MODULE__, :ok, options)
  end

  def stop(), do: GenServer.call(self(), :stop)
  def get_state(pid), do: GenServer.call(pid, :getstate, 30_000)
  def fetch_schedule(), do: GenServer.cast(self(), :fetch_schedule)
  def custom_date(pid, date), do: GenServer.cast(pid, {:custom_date, date})

  ##############################
  # SERVER CALLBACKS
  ##############################
  ##############################

  def init(:ok) do
    #################
    # Constants
    #################
    config = %{
      born: DateTime.utc_now(),
      last_updated: 0,
      heartbeat: 0,
      date: Date.to_iso8601(DateTime.utc_now() |> DateTime.add(-7 * 3600, :second)),
      gamemaps: []
    }

    tables = [
      :espn_nflschedule
    ]

    gamedataslug = []

    Enum.each(tables, fn table ->
      :ets.new(table, [
        :set,
        :named_table,
        :public,
        read_concurrency: true,
        write_concurrency: true
      ])

      ## initialize slugs
      :ets.insert(table, {table |> Atom.to_string(), gamedataslug})
    end)

    #################
    # Summon Schedule
    #################
    __MODULE__.fetch_schedule()

    schedule_scraper()
    ## scheduler
    {:ok, config}
  end

  def handle_call(:getstate, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  def handle_info(:work, state) do
    __MODULE__.fetch_schedule()
    ############################
    ## Schedule a timeout
    #############################
    schedule_scraper()
    {:noreply, state}
  end

  ###############################
  ## Custom Functions
  ###############################
  ###############################
  ###############################
  @doc """
  Updates the date in the state
  """
  def handle_cast({:custom_date, date}, state) do
    {:noreply, %{state | date: date}}
  end

  def handle_cast(:fetch_schedule, state) do
    {:ok, response} =
      NflEspnClient.get(
        "header?sport=football&league=nfl&region=us&lang=en&contentorigin=espn&buyWindow=1m&showAirings=buy%2Clive%2Creplay&showZipLookup=true&tz=America%2FNew_York"
      )

    ## do stuff with response
    gamemaps =
      case response |> Map.get(:body) do
        "Invalid game date" ->
          {:error,
           "Please provide a legitimate game date.  Your provided #{state.date} which is invalid"}

       _body ->
          gameset =
            response.body
            |> Map.get("sports")
            |> Enum.at(0)
            |> Map.get("leagues")
            |> Enum.at(0)
            |> Map.get("events")

          ## reduce games into schedule slugs
          Enum.reduce(gameset, %{}, fn game, acc ->
            gamestring = game |> Map.get("id")

            ## awayteam
            awaydata = game |> Map.get("competitors") |> Enum.at(0)

            [awaywins, awaylosses] =
              awaydata
              |> Map.get("record")
              |> String.split("-")
              |> Enum.map(fn v -> String.to_integer(v) end)

            ## hometeam
            homedata = game |> Map.get("competitors") |> Enum.at(1)

            [homewins, homelosses] =
              homedata
              |> Map.get("record")
              |> String.split("-")
              |> Enum.map(fn v -> String.to_integer(v) end)

            gamemap = %{
              awayabbr: awaydata |> Map.get("abbreviation"),
              awayteam: awaydata |> Map.get("displayName"),
              awayscore:
                case awaydata |> Map.get("score") do
                  "" -> 0
                  score -> score
                end,
              awaywins: awaywins,
              awaylosses: awaylosses,
              date: game |> Map.get("date") |> String.split("T") |> Enum.at(0),
              gamestate:
                game |> Map.get("fullStatus") |> Map.get("type") |> Map.get("description"),
              gid: game |> Map.get("id"),
              homeabbr: homedata |> Map.get("abbreviation"),
              hometeam: homedata |> Map.get("displayName"),
              homescore:
                case homedata |> Map.get("score") do
                  "" -> 0
                  score -> score
                end,
              homewins: homewins,
              homelosses: homelosses,
              starttime:
                game
                |> Map.get("fullStatus")
                |> Map.get("type")
                |> Map.get("shortDetail")
                |> String.split("- ")
                |> Enum.at(1),
              status:
                case game |> Map.get("fullStatus") |> Map.get("type") |> Map.get("state") do
                  "pre" -> "Pre-Game"
                  "final" -> "Final"
                  _ -> "In Game"
                end,
              league: "Nfl",
              sport: "Football" 
            }

            ## Put the new map into the accumulator with gamestring as key
            Map.put(acc, gamestring, gamemap)
          end)
      end

    ## state
    {:noreply,
     %{
       state
       | gamemaps: gamemaps,
         heartbeat: state.heartbeat + 1,
         last_updated: DateTime.utc_now() |> DateTime.add(-8 * 3600, :second)
     }}
  end

  def schedule_scraper() do
    Process.send_after(self(), :work, 60_000)
  end
end

"""
    gamemaps =
      case response |> Map.get(:body) do
        "Invalid game date" ->
          {:error,
           "Please provide a legitimate game date.  Your provided {state.date} which is invalid"}

        body ->
          gameset =
            case body["dates"] do
              [] ->
                %{}

              _ ->
                body["dates"]
                |> Enum.at(0)
                |> Map.get("games")
            end

          ## reduce games into schedule slugs
          Enum.reduce(gameset, %{}, fn game, acc ->
            gamestring = game |> Map.get("gamePk")

            awayteam =
              game
              |> Map.get("teams")
              |> Map.get("away")
              |> Map.get("team")
              |> Map.get("name")

            hometeam =
              game
              |> Map.get("teams")
              |> Map.get("home")
              |> Map.get("team")
              |> Map.get("name")

            gamemap = %{
              awayabbr: awayteam |> Nhl.fullname_to_abbr(),
              awayteam: awayteam,
              awayscore:
                case game |> Map.get("teams") |> Map.get("away") |> Map.get("score") do
                  nil -> 0
                  val -> val
                end,
              awaywins:
                game
                |> Map.get("teams")
                |> Map.get("away")
                |> Map.get("leagueRecord")
                |> Map.get("wins"),
              awaylosses:
                game
                |> Map.get("teams")
                |> Map.get("away")
                |> Map.get("leagueRecord")
                |> Map.get("losses"),
              date: game |> Map.get("officialDate"),
              gamestate: game |> Map.get("status") |> Map.get("abstractGameState"),
              gid: game |> Map.get("gamePk"),
              homeabbr: hometeam |> Nhl.fullname_to_abbr(),
              hometeam: hometeam,
              homescore:
                case game |> Map.get("teams") |> Map.get("home") |> Map.get("score") do
                  nil -> 0
                  val -> val
                end,
              homewins:
                game
                |> Map.get("teams")
                |> Map.get("home")
                |> Map.get("leagueRecord")
                |> Map.get("wins"),
              homelosses:
                game
                |> Map.get("teams")
                |> Map.get("home")
                |> Map.get("leagueRecord")
                |> Map.get("losses"),
              starttime:
                game
                |> Map.get("gameDate")
                |> DateTime.from_iso8601()
                |> elem(1)
                |> DateTime.add(-7 * 3600, :second),
              status: game |> Map.get("status") |> Map.get("detailedState")
            }

            Map.put(acc, gamestring, gamemap)
          end)
      end

"""
