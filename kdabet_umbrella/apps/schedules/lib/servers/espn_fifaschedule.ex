defmodule Schedules.Fifa.Espn do
  use GenServer
  alias Schedules.NflEspnClient
  alias Core.Common
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
      :espn_fifaschedule
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
        "header?sport=soccer&region=us&lang=en&contentorigin=espn&buyWindow=1m&showAirings=buy%2Clive%2Creplay&showZipLookup=true&tz=America%2FNew_York"
      )

    ## do stuff with response
    gamemaps =
      case response |> Map.get(:body) do
        "Invalid game date" ->
          {:error,
           "Please provide a legitimate game date.  Your provided {state.date} which is invalid"}

        _body ->
          ## fetch per league data,  enumerate through it and create game maps.
          leagueset =
            response.body
            |> Map.get("sports")
            |> Enum.at(0)
            |> Map.get("leagues")

          ## Enumerate through the leagues and create state
          Enum.map(leagueset, fn league ->
            ## for each league get games and reduce the games to a Schedule.FIFA Struct
            gameset = league |> Map.get("events")

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
                |> case do
                  [w, l] -> [w, l]
                  [w, l, _t] -> [w, l]
                  _ -> [0, 0]
                end

              # hometeam
              homedata = game |> Map.get("competitors") |> Enum.at(1)

              [homewins, homelosses] =
                homedata
                |> Map.get("record")
                |> String.split("-")
                |> Enum.map(fn v -> String.to_integer(v) end)
                |> case do
                  [w, l] -> [w, l]
                  [w, l, _t] -> [w, l]
                  _ -> [0, 0]
                end

              # Getting Start Time If applicable
              maybe_time =
                game
                |> Map.get("fullStatus")
                |> Map.get("type")
                |> Map.get("detail")

              start_time =
                cond do
                  String.match?(maybe_time, ~r/FT/) ->
                    "Final"

                  String.match?(maybe_time, ~r/HT/) ->
                    "Half Time"

                  String.match?(maybe_time, ~r/\d+'/) ->
                    "In Game"

                  String.match?(maybe_time, ~r/\d+'[\+]\d+'/) ->
                    "Injury Time"

                  true ->
                    maybe_time
                    |> Common.parse_custom_datetime_string()
                    |> elem(1)
                end

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
                starttime: start_time,
                status:
                  case game |> Map.get("fullStatus") |> Map.get("type") |> Map.get("state") do
                    "pre" -> "Pre-Game"
                    "final" -> "Final"
                    _ -> "In Game"
                  end
              }

              ## insert the Schedule structure into the game map with a key -> value pair
              Map.put(acc, gamestring, gamemap)
            end)
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
