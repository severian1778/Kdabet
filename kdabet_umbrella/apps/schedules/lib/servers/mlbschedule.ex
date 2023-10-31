defmodule Schedules.Mlb.Official do
  use GenServer
  alias Schedules.MlbOfficialClient

  alias Core.Common.Mlb
  #############################
  # Client API
  #############################
  #############################

  @moduledoc """
  MlbSchedule pipes the game status directly from MLBAM API.
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
      :schedule
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

      # initialize slugs
      :ets.insert(table, {table |> Atom.to_string(), gamedataslug})
    end)

    #################
    # Summon Schedule
    #################
    fetch_schedule()

    ## work scheduler
    schedule_scraper()

    {:ok, config}
  end

  def handle_call(:getstate, _from, state), do: {:reply, state, state}

  def handle_call(:stop, _from, state), do: {:stop, :normal, :ok, state}

  def handle_info(:work, state) do
    fetch_schedule()
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
    {:ok, response} = MlbOfficialClient.get("/schedule/?sportId=1&date=#{state.date}")

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
            awayabbr =
              game
              |> Map.get("teams")
              |> Map.get("away")
              |> Map.get("team")
              |> Map.get("name")
              |> Mlb.mlbtoabbr()
              |> Mlb.mlbtoroto()

            homeabbr =
              game
              |> Map.get("teams")
              |> Map.get("home")
              |> Map.get("team")
              |> Map.get("name")
              |> Mlb.mlbtoabbr()
              |> Mlb.mlbtoroto()

            dblhdr =
              Enum.filter(acc, fn g ->
                g |> elem(1) |> Map.get(:awayabbr) == awayabbr
              end)
              |> length

            gameraw =
              Enum.join([
                state.date |> String.replace("-", "/"),
                "/",
                awayabbr,
                "mlb-",
                homeabbr,
                "mlb-",
                dblhdr + 1
              ])

            gamestring =
              cond do
                Map.has_key?(acc, gameraw) ->
                  Enum.join([
                    state.date |> String.replace("-", "/"),
                    "/",
                    awayabbr,
                    "mlb-",
                    homeabbr,
                    "mlb-",
                    dblhdr + 1
                  ])

                true ->
                  gameraw
              end

            gamemap = %{
              awayabbr: awayabbr,
              awayteam:
                game
                |> Map.get("teams")
                |> Map.get("away")
                |> Map.get("team")
                |> Map.get("name")
                |> String.replace("Indians", "Guardians"),
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
              homeabbr: homeabbr,
              hometeam:
                game
                |> Map.get("teams")
                |> Map.get("home")
                |> Map.get("team")
                |> Map.get("name")
                |> String.replace("Indians", "Guardians"),
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
              league: "Mlb",
              sport: "Baseball"
            }

            Map.put(acc, gamestring, gamemap)
          end)
      end

    #############################
    ## Update ETS.
    #############################
    :ets.insert(:schedule, {"schedule", gamemaps})

    {:noreply,
     %{
       state
       | gamemaps: gamemaps,
         heartbeat: state.heartbeat + 1,
         last_updated: DateTime.utc_now() |> DateTime.add(-7 * 3600, :second)
     }}
  end

  def schedule_scraper() do
    Process.send_after(self(), :work, 10_000)
  end
end
