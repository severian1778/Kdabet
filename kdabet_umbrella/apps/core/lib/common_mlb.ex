defmodule Core.Common.Mlb do
  @moduledoc """
  Common functions relating to MLB data.
  """

  @doc """
  Scrubs rotowire team abbreviations and returns standard mlb abbreviations
  iex(1)> scrubtoroto("sln")
          return ->  "stl"
  """
  @spec scrubroto(binary()) :: binary()
  def scrubroto(str) do
    ## teamnames are all fucked up.
    str
    |> String.replace("sln", "stl")
    |> String.replace("chn", "chc")
    |> String.replace("tba", "tbr")
    |> String.replace("sfn", "sfg")
    |> String.replace("kca", "kcr")
    |> String.replace("sdn", "sdp")
    |> String.replace("nya", "nyy")
    |> String.replace("lan", "lad")
    |> String.replace("nyn", "nym")
    |> String.replace("lan", "lad")
    |> String.replace("cha", "chw")
    |> String.replace("ana", "laa")
    |> String.replace("was", "wsh")
  end

  @doc """
  Scrubs random abbreviations and returns a standard
  iex(1)> standardabbr("was")
          return ->  "wsh"
  """
  @spec standardabbr(binary()) :: binary()
  def standardabbr(str) do
    str
    |> String.replace("was", "wsh")
    |> String.replace("sfg", "sf")
    |> String.replace("sdp", "sd")
    |> String.replace("chw", "cws")
    |> String.replace("D-Backs", "ari")
    |> String.replace("tbr", "tb")
    |> String.replace("kcr", "kc")
  end

  @doc """
  Scrubs full team names and returns a standard abbreviation
  iex(1)> teamtoabbr("Cardinals")
          return ->  "stl"
  """
  @spec teamtoabbr(binary()) :: binary()
  def teamtoabbr(str) do
    str
    |> String.replace("Cardinals", "stl")
    |> String.replace("Cubs", "chc")
    |> String.replace("Rays", "tbr")
    |> String.replace("Giants", "sfg")
    |> String.replace("Royals", "kcr")
    |> String.replace("Padres", "sdp")
    |> String.replace("Yankees", "nyy")
    |> String.replace("Dodgers", "lad")
    |> String.replace("Mets", "nym")
    |> String.replace("White Sox", "chw")
    |> String.replace("Angels", "laa")
    |> String.replace("Rockies", "col")
    |> String.replace("Red Sox", "bos")
    |> String.replace("Blue Jays", "tor")
    |> String.replace("Brewers", "mil")
    |> String.replace("Athletics", "oak")
    |> String.replace("D-backs", "ari")
    |> String.replace("Rangers", "tex")
    |> String.replace("Astros", "hou")
    |> String.replace("Braves", "atl")
    |> String.replace("Marlins", "mia")
    |> String.replace("Mariners", "sea")
    |> String.replace("Twins", "min")
    |> String.replace("Tigers", "det")
    |> String.replace("Phillies", "phi")
    |> String.replace("Pirates", "pit")
    |> String.replace("Reds", "cin")
    |> String.replace("Orioles", "bal")
    |> String.replace("Nationals", "was")
    |> String.replace("Indians", "cle")
    |> String.replace("Guardians", "cle")
  end

  @doc """
  Scrubs full team names and returns a park number
  iex(1)> teamtoabbr("Cardinals")
          return ->  1
  """
  @spec teamtoparknum(binary()) :: integer()
  def teamtoparknum(str) do
    ## teamnames are all fucked up.
    str
    |> String.replace("Cardinals", "1")
    |> String.replace("Cubs", "2")
    |> String.replace("Rays", "3")
    |> String.replace("Giants", "4")
    |> String.replace("Royals", "5")
    |> String.replace("Padres", "6")
    |> String.replace("Yankees", "7")
    |> String.replace("Dodgers", "8")
    |> String.replace("Mets", "9")
    |> String.replace("White Sox", "10")
    |> String.replace("Angels", "11")
    |> String.replace("Rockies", "12")
    |> String.replace("Red Sox", "13")
    |> String.replace("Blue Jays", "14")
    |> String.replace("Brewers", "15")
    |> String.replace("Athletics", "16")
    |> String.replace("D-backs", "17")
    |> String.replace("Rangers", "18")
    |> String.replace("Astros", "19")
    |> String.replace("Braves", "20")
    |> String.replace("Marlins", "21")
    |> String.replace("Mariners", "22")
    |> String.replace("Twins", "23")
    |> String.replace("Tigers", "24")
    |> String.replace("Phillies", "25")
    |> String.replace("Pirates", "26")
    |> String.replace("Reds", "27")
    |> String.replace("Orioles", "28")
    |> String.replace("Nationals", "29")
    |> String.replace("Indians", "30")
    |> String.replace("Guardians", "30")
    |> String.to_integer()
  end

  @doc """
  Scrubs abbreviations and returns full team names
  iex(1)> abbrtoteam("stl")
          return ->  "Cardinals"
  """
  @spec abbrtoteam(binary()) :: binary()
  def abbrtoteam(str) do
    ## teamnames are all fucked up.
    str
    |> String.replace("stl", "Cardinals")
    |> String.replace("chc", "Cubs")
    |> String.replace("tbr", "Rays")
    |> String.replace("sfg", "Giants")
    |> String.replace("kcr", "Royals")
    |> String.replace("sdp", "Padres")
    |> String.replace("nyy", "Yankees")
    |> String.replace("lad", "Dodgers")
    |> String.replace("nym", "Mets")
    |> String.replace("chw", "White Sox")
    |> String.replace("cws", "White Sox")
    |> String.replace("laa", "Angels")
    |> String.replace("col", "Rockies")
    |> String.replace("bos", "Red Sox")
    |> String.replace("tor", "Blue Jays")
    |> String.replace("mil", "Brewers")
    |> String.replace("oak", "Athletics")
    |> String.replace("ari", "D-backs")
    |> String.replace("tex", "Rangers")
    |> String.replace("hou", "Astros")
    |> String.replace("atl", "Braves")
    |> String.replace("mia", "Marlins")
    |> String.replace("sea", "Mariners")
    |> String.replace("min", "Twins")
    |> String.replace("det", "Tigers")
    |> String.replace("phi", "Phillies")
    |> String.replace("pit", "Pirates")
    |> String.replace("cin", "Reds")
    |> String.replace("bal", "Orioles")
    |> String.replace("was", "Nationals")
    |> String.replace("wsh", "Nationals")
    |> String.replace("cle", "Indians")
  end

  @doc """
  Scrubs standard mlb abbreviations and returns rotowire standard abbreviations
  iex(1)> mlbtoroto("Cardinals")
          return ->  "stl"
  """
  @spec mlbtoroto(binary()) :: binary()
  def mlbtoroto(str) do
    str
    |> String.replace("stl", "sln")
    |> String.replace("chc", "chn")
    |> String.replace("tbr", "tba")
    |> String.replace("sfg", "sfn")
    |> String.replace("kcr", "kca")
    |> String.replace("sdp", "sdn")
    |> String.replace("nyy", "nya")
    |> String.replace("lad", "lan")
    |> String.replace("nym", "nyn")
    |> String.replace("lad", "lan")
    |> String.replace("chw", "cha")
    |> String.replace("laa", "ana")
    |> String.replace("wsh", "was")
    |> String.replace("cws", "cha")
    |> String.replace("tbr", "tba")
    |> String.replace("kcr", "kca")
    |> String.replace("sfg", "sfn")
    |> String.replace("sdp", "sdn")

    # |> String.replace("tb", "tba")
    # |> String.replace("kc", "kca")
    # |> String.replace("sf", "sfn")
    # |> String.replace("sd", "sdn")
  end

  @doc """
  Scrubs standard mlb full cityteam names and returns mlb standard abbreviations
  iex(1)> mlbtoabbr("St. Louis Cardinals")
          return ->  "stl"
  """
  @spec mlbtoabbr(binary()) :: binary()
  def mlbtoabbr(str) do
    ## teamnames are all fucked up.
    str
    |> String.replace("St. Louis Cardinals", "stl")
    |> String.replace("Chicago Cubs", "chc")
    |> String.replace("Tampa Bay Rays", "tbr")
    |> String.replace("San Francisco Giants", "sfg")
    |> String.replace("Kansas City Royals", "kcr")
    |> String.replace("San Diego Padres", "sdp")
    |> String.replace("New York Yankees", "nyy")
    |> String.replace("Los Angeles Dodgers", "lad")
    |> String.replace("New York Mets", "nym")
    |> String.replace("Chicago White Sox", "chw")
    |> String.replace("Los Angeles Angels", "laa")
    |> String.replace("Colorado Rockies", "col")
    |> String.replace("Boston Red Sox", "bos")
    |> String.replace("Toronto Blue Jays", "tor")
    |> String.replace("Milwaukee Brewers", "mil")
    |> String.replace("Oakland Athletics", "oak")
    |> String.replace("Arizona Diamondbacks", "ari")
    |> String.replace("Texas Rangers", "tex")
    |> String.replace("Houston Astros", "hou")
    |> String.replace("Atlanta Braves", "atl")
    |> String.replace("Miami Marlins", "mia")
    |> String.replace("Seattle Mariners", "sea")
    |> String.replace("Minnesota Twins", "min")
    |> String.replace("Detroit Tigers", "det")
    |> String.replace("Philadelphia Phillies", "phi")
    |> String.replace("Pittsburgh Pirates", "pit")
    |> String.replace("Cincinnati Reds", "cin")
    |> String.replace("Baltimore Orioles", "bal")
    |> String.replace("Washington Nationals", "was")
    |> String.replace("Cleveland Guardians", "cle")
    |> String.replace("Cleveland Indians", "cle")
  end

  ###################################
  ## Generate an Erlang Date Tuple
  ###################################
  @doc """
  Returns a pure erlang date tuple from Erlang calendar function with leadning zeros
  iex(1)> date()
          return ->  {2019, 12, 04}, {04, 30, 30}
  """
  @spec date() :: tuple()
  def date do
    {{year, month, day}, {hours, minutes, seconds}} = :calendar.local_time()
    ## BUILD DATESTRING
    hours =
      if hours < 10 do
        Enum.join([0, hours]) |> String.to_integer()
      else
        hours
      end

    minutes =
      if minutes < 10 do
        Enum.join([0, minutes]) |> String.to_integer()
      else
        minutes
      end

    seconds =
      if seconds < 10 do
        Enum.join({0, seconds}) |> String.to_integer()
      else
        seconds
      end

    {{year, month, day}, {hours, minutes, seconds}}
  end

  def monthandday() do
    ## snag the YVR date.
    datenow = Timex.now() |> Timex.shift(hours: -8) |> Timex.to_date()

    month =
      if datenow.month < 10 do
        Enum.join([0, datenow.month])
      else
        datenow.month
        |> to_string
      end

    day =
      if datenow.day < 10 do
        Enum.join([0, datenow.day])
      else
        datenow.day
        |> to_string
      end

    ## return
    {month, day}
  end

  @doc """
  Returns a string representing the current data in condensed yyyymmdd format
  iex(1)> yyyymmdd()
          return ->  "20180404"
  """
  @spec yyyymmdd() :: binary()
  ## Return todays date in string format with yyyy-mm-dd format
  def yyyymmdd do
    datenow = Timex.now() |> Timex.shift(hours: -8) |> Timex.to_date()
    year = datenow.year |> Integer.to_string()
    month = monthandday() |> elem(0)

    day =
      if datenow.day < 10 do
        Enum.join([0, datenow.day - 1])
      else
        (datenow.day - 1)
        |> to_string
      end

    Enum.join([year, month, day], "-")
  end

  @doc """
  takes in a standard datestring and returns a unix time
  iex(1)> datestring_to_unix("2019-04-23")
          return ->  "2019-04-23 00:00:00"
  """
  def datestring_to_unix(date) do
    datestring = date <> " 00:00:00"
    {:ok, naive} = NaiveDateTime.from_iso8601(datestring)
    {:ok, datetime} = DateTime.from_naive(naive, "Etc/UTC")
    DateTime.to_unix(datetime)
  end
end
