defmodule Schedules.Mlb.Official do
  use GenServer
  alias Schedules.MlbOfficialClient

  alias Core.Common
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

  def stop(), do: GenServer.call(__MODULE__, :stop)
  def get_state(pid), do: GenServer.call(pid, {:getstate, pid}, 30_000)
  def fetch_schedule(), do: GenServer.cast(__MODULE__, :fetch_schedule)
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
      date: Date.to_iso8601(DateTime.utc_now() |> DateTime.add(-8 * 3600, :second)),
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

      #
      #  ## initialize slugs
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

  def handle_call({:getstate, _pid}, _from, state), do: {:reply, state, state}

  def handle_call(:stop, _from, state), do: {:stop, :normal, :ok, state}

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
              |> Common.mlbtoabbr()
              |> Common.mlbtoroto()

            homeabbr =
              game
              |> Map.get("teams")
              |> Map.get("home")
              |> Map.get("team")
              |> Map.get("name")
              |> Common.mlbtoabbr()
              |> Common.mlbtoroto()

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
              homeabbr: homeabbr,
              awayscore: game |> Map.get("teams") |> Map.get("away") |> Map.get("score"),
              homescore: game |> Map.get("teams") |> Map.get("home") |> Map.get("score"),
              seriesGameNumber: game |> Map.get("seriesGameNumber"),
              status: game |> Map.get("status") |> Map.get("detailedState"),
              gametime: game |> Map.get("status") |> Map.get("abstractGameState"),
              game_pk: game |> Map.get("gamePk"),
              awayteam:
                game
                |> Map.get("teams")
                |> Map.get("away")
                |> Map.get("team")
                |> Map.get("name")
                |> String.replace("Indians", "Guardians"),
              hometeam:
                game
                |> Map.get("teams")
                |> Map.get("home")
                |> Map.get("team")
                |> Map.get("name")
                |> String.replace("Indians", "Guardians"),
              awaywins:
                game
                |> Map.get("teams")
                |> Map.get("away")
                |> Map.get("leagueRecord")
                |> Map.get("wins"),
              awayloss:
                game
                |> Map.get("teams")
                |> Map.get("away")
                |> Map.get("leagueRecord")
                |> Map.get("losses"),
              homewins:
                game
                |> Map.get("teams")
                |> Map.get("home")
                |> Map.get("leagueRecord")
                |> Map.get("wins"),
              homeloss:
                game
                |> Map.get("teams")
                |> Map.get("home")
                |> Map.get("leagueRecord")
                |> Map.get("losses")
            }

            Map.put(acc, gamestring, gamemap)
          end)
      end

    #############################
    ## Update ETS.
    #############################
    :ets.insert(:schedule, {"schedule", gamemaps})

    ## state
    {:noreply, %{state | gamemaps: gamemaps}}
  end

  def schedule_scraper() do
    Process.send_after(self(), :work, 10_000)
  end
end
