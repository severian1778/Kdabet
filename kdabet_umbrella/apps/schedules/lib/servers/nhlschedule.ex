defmodule Schedules.Nhl.Official do
  use GenServer
  alias Schedules.NhlOfficialClient

  alias Core.Common.Nhl
  #############################
  # Client API
  #############################
  #############################

  @moduledoc """
  NbaSchedule pipes the game status directly from NBA API.
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
      :nhlschedule
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
      NhlOfficialClient.get("api/v1/schedule?date=#{state.date}")

    gamemaps =
      case response |> Map.get(:body) do
        "Invalid game date" ->
          {:error,
           "Please provide a legitimate game date.  Your provided #{state.date} which is invalid"}

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
              status: game |> Map.get("status") |> Map.get("detailedState"),
              league: "Nhl",
              sport: "Hockey"
            }

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
          matchups = body |> Map.get("resultSets")

          ## The structure of the api return is very convoluted so we split it up
          matches = matchups |> Enum.at(0) |> Map.get("rowSet")
          date = body |> Map.get("parameters") |> Map.get("GameDate")
          datenum = String.replace(date, "-", "") |> String.to_integer()
          scoresets = matchups |> Enum.at(1) |> Map.get("rowSet")

          ## Conference standings
          standings =
            (matchups |> Enum.at(4) |> Map.get("rowSet")) ++
              (matchups |> Enum.at(5) |> Map.get("rowSet"))

          ## Gather a list of matchups and construct the slug set
          Enum.reduce(Enum.to_list(1..(matches |> length)), %{}, fn indice, acc ->
            matchup = matches |> Enum.at(indice - 1)
            gid = matchup |> Enum.at(2)

            ## Away Record
            [awaywins, awaylosses] =
              Enum.filter(standings, fn [h | t] ->
                [matchup |> Enum.at(7) | t] == [h | t]
              end)
              |> Enum.at(0)
              |> Enum.slice(7..8)

            ## Away Record
            [homewins, homelosses] =
              Enum.filter(standings, fn [h | t] ->
                [matchup |> Enum.at(6) | t] == [h | t]
              end)
              |> Enum.at(0)
              |> Enum.slice(7..8)

            slug =
              %{
                awayabbr:
                  matchup
                  |> Enum.at(7)
                  |> Core.Common.Nba.teamid_to_teamabbr()
                  |> String.downcase(),
                awayteam:
                  Enum.join([
                    matchup |> Enum.at(7) |> Core.Common.Nba.teamid_to_city(),
                    " ",
                    matchup |> Enum.at(7) |> Core.Common.Nba.teamid_to_teamname()
                  ]),
                awayscore:
                  case scoresets |> Enum.at(2 * (indice - 1)) |> Enum.at(21) do
                    nil -> 0
                    a -> a
                  end,
                awaywins: awaywins,
                awaylosses: awaylosses,
                gid: gid,
                homeabbr:
                  matchup
                  |> Enum.at(6)
                  |> Core.Common.Nba.teamid_to_teamabbr()
                  |> String.downcase(),
                hometeam:
                  Enum.join([
                    matchup |> Enum.at(6) |> Core.Common.Nba.teamid_to_city(),
                    " ",
                    matchup |> Enum.at(6) |> Core.Common.Nba.teamid_to_teamname()
                  ]),
                homescore:
                  case scoresets |> Enum.at(2 * (indice - 1) + 1) |> Enum.at(21) do
                    nil -> 0
                    a -> a
                  end,
                homewins: homewins,
                homelosses: homelosses,
                date: date,
                starttime: matchup |> Enum.at(4),
                status:
                  case matchup |> Enum.at(3) do
                    1 -> "Pre-Game"
                    3 -> "Final"
                    _ -> "In-Progress"
                  end
              }

            Map.put(acc, gid, slug)
          end)
      end

    #############################
    ## Update ETS.
    #############################
    :ets.insert(
      :nbaschedule,
      {"schedule", gamemaps}
    )


"""
