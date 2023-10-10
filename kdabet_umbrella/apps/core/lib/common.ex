defmodule Core.Common do
  @doc """
  Function => Pad Dates.
    - arity(0)
    - return <string>
  """

  def padint(num) do
    num |> Integer.to_string() |> String.pad_leading(2, "0")
  end

  ## handy function for replicating a vaue in a list
  def replicate(n, x), do: for(_ <- 1..n, do: x)

  ## handy method for adding up lists.of numbers
  def arraysum(to_add, agg) do
    Enum.map(agg |> Enum.with_index(), fn {feature, idx} ->
      feature + (to_add |> Enum.at(idx))
    end)
  end

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

  def standardabbr(str) do
    ## teamnames are all fucked up.
    str
    |> String.replace("was", "wsh")
    |> String.replace("sfg", "sf")
    |> String.replace("sdp", "sd")
    |> String.replace("chw", "cws")
    |> String.replace("D-Backs", "ARI")
    |> String.replace("tbr", "tb")
    |> String.replace("kcr", "kc")
  end

  def teamtoabbr(str) do
    ## teamnames are all fucked up.
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

  def mlbtoroto(str) do
    ## teamnames are all fucked up.
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

  def sbrabbr_to_mlb(str) do
    ## teamnames are all fucked up.
    str
    |> String.replace("stl", "St. Louis Cardinals")
    |> String.replace("chc", "Chicago Cubs")
    |> String.replace("chn", "Chicago Cubs")
    |> String.replace("tba", "Tampa Bay Rays")
    |> String.replace("tbr", "Tampa Bay Rays")
    |> String.replace("tb", "Tampa Bay Rays")
    |> String.replace("sfg", "San Francisco Giants")
    |> String.replace("sfn", "San Francisco Giants")
    |> String.replace("sf", "San Francisco Giants")
    |> String.replace("kca", "Kansas City Royals")
    |> String.replace("kcr", "Kansas City Royals")
    |> String.replace("kc", "Kansas City Royals")
    |> String.replace("sdn", "San Diego Padres")
    |> String.replace("sdp", "San Diego Padres")
    |> String.replace("sd", "San Diego Padres")
    |> String.replace("nyy", "New York Yankees")
    |> String.replace("lad", "Los Angeles Dodgers")
    |> String.replace("nym", "New York Mets")
    |> String.replace("nyn", "New York Mets")
    |> String.replace("chw", "Chicago White Sox")
    |> String.replace("cha", "Chicago White Sox")
    |> String.replace("cws", "Chicago White Sox")
    |> String.replace("laa", "Los Angeles Angels")
    |> String.replace("col", "Colorado Rockies")
    |> String.replace("bos", "Boston Red Sox")
    |> String.replace("tor", "Toronto Blue Jays")
    |> String.replace("mil", "Milwaukee Brewers")
    |> String.replace("oak", "Oakland Athletics")
    |> String.replace("ari", "Arizona Diamondbacks")
    |> String.replace("tex", "Texas Rangers")
    |> String.replace("hou", "Houston Astros")
    |> String.replace("atl", "Atlanta Braves")
    |> String.replace("mia", "Miami Marlins")
    |> String.replace("sea", "Seattle Mariners")
    |> String.replace("min", "Minnesota Twins")
    |> String.replace("det", "Detroit Tigers")
    |> String.replace("phi", "Philadelphia Phillies")
    |> String.replace("pit", "Pittsburgh Pirates")
    |> String.replace("cin", "Cincinnati Reds")
    |> String.replace("bal", "Baltimore Orioles")
    |> String.replace("was", "Washington Nationals")
    |> String.replace("wsh", "Washington Nationals")
    |> String.replace("cle", "Cleveland Guardians")
  end

  def sbrid_to_tid(sbrid) when is_integer(sbrid) do
    case sbrid do
      610 -> "Minnesota Twins"
      620 -> "Tampa Bay Rays"
      607 -> "Cleveland Guardians"
      609 -> "Chicago Cubs"
      608 -> "Kansas City Royals"
      613 -> "Texas Rangers"
      628 -> "Pittsburgh Pirates"
      631 -> "Milwaukee Brewers"
      616 -> "Baltimore Orioles"
      636 -> "San Francisco Giants"
      611 -> "Detroit Tigers"
      625 -> "Atlanta Braves"
      623 -> "Washington Nationals"
      629 -> "Cincinnati Reds"
      617 -> "Boston Red Sox"
      618 -> "New York Yankees"
      626 -> "Chicago Cubs"
      627 -> "St. Louis Cardinals"
      614 -> "Los Angeles Angels"
      615 -> "Seattle Mariners"
      619 -> "Toronto Blue Jays"
      634 -> "Colorado Rockies"
      612 -> "Oakland Athletics"
      630 -> "Houston Astros"
      624 -> "Miami Marlins"
      632 -> "San Diego Padres"
      622 -> "New York Mets"
      633 -> "Arizona Diamondbacks"
      621 -> "Philadelphia Phillies"
      635 -> "Los Angeles Dodgers"
      753 -> "Cleveland Guardians"
    end
  end

  ###################################
  ## Generate an Erlang Date Tuple
  ###################################
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

  #################################
  ## Generate a list of pitch columns to scrub
  #################################
  def namestoscrub do
    [
      "x",
      "y",
      "x0",
      "y0",
      "z0",
      "ay",
      "az",
      "ax",
      "vy0",
      "vz0",
      "vx0",
      "px",
      "pz",
      "pfx_x",
      "pfx_z",
      "ax",
      "az",
      "sz_bot",
      "sz_top",
      "spin_dir",
      "spin_rate",
      "start_speed",
      "end_speed"
    ]
  end

  def team_check(str) do
    ## teamnames are all resolved to a full string name of a giventeam.
    dstr = String.downcase(str)

    cond do
      ["stl", "cardinals"] |> Enum.member?(dstr) -> "Cardinals"
      ["chc", "cubs"] |> Enum.member?(dstr) -> "Cubs"
      ["tbr", "rays"] |> Enum.member?(dstr) -> "Rays"
      ["sfg", "giants"] |> Enum.member?(dstr) -> "Giants"
      ["kcr", "royals"] |> Enum.member?(dstr) -> "Royals"
      ["sdp", "padres"] |> Enum.member?(dstr) -> "Padres"
      ["nyy", "yankees"] |> Enum.member?(dstr) -> "Yankees"
      ["lad", "dodgers"] |> Enum.member?(dstr) -> "Dodgers"
      ["nym", "mets"] |> Enum.member?(dstr) -> "Mets"
      ["chw", "white sox"] |> Enum.member?(dstr) -> "White Sox"
      ["laa", "angels"] |> Enum.member?(dstr) -> "Angels"
      ["col", "rockies"] |> Enum.member?(dstr) -> "Rockies"
      ["bos", "red sox"] |> Enum.member?(dstr) -> "Red Sox"
      ["tor", "blue jays"] |> Enum.member?(dstr) -> "Blue Jays"
      ["mil", "brewers"] |> Enum.member?(dstr) -> "Brewers"
      ["oak", "athletics"] |> Enum.member?(dstr) -> "Athletics"
      ["ari", "d-backs"] |> Enum.member?(dstr) -> "D-backs"
      ["tex", "rangers"] |> Enum.member?(dstr) -> "Rangers"
      ["hou", "astros"] |> Enum.member?(str) -> "Astros"
      ["atl", "braves"] |> Enum.member?(dstr) -> "Braves"
      ["mia", "marlins"] |> Enum.member?(dstr) -> "Marlins"
      ["sea", "mariners"] |> Enum.member?(dstr) -> "Mariners"
      ["min", "twins"] |> Enum.member?(dstr) -> "Twins"
      ["det", "tigers"] |> Enum.member?(dstr) -> "Tigers"
      ["phi", "phillies"] |> Enum.member?(dstr) -> "Phillies"
      ["pit", "pirates"] |> Enum.member?(dstr) -> "Pirates"
      ["cin", "reds"] |> Enum.member?(dstr) -> "Reds"
      ["bal", "orioles"] |> Enum.member?(dstr) -> "Orioles"
      ["was", "nationals"] |> Enum.member?(dstr) -> "Nationals"
      ["cle", "indians"] |> Enum.member?(dstr) -> "Indians"
      true -> nil
    end
  end

  def pitchstruct(pitch) do
    %{
      gid: pitch.gid,
      abid: pitch.abid,
      pitchid: pitch.pitchid,
      ay: pitch.ay,
      ptype: pitch.pitch_type,
      px: pitch.px,
      pz: pitch.pz,
      vz0: pitch.vz0,
      vx0: pitch.vx0,
      start_speed: pitch.start_speed,
      vy0: pitch.vy0,
      des: pitch.des,
      ax: pitch.ax,
      z0: pitch.z0,
      az: pitch.az,
      x0: pitch.x0,
      y0: 50.0
    }
  end

  ## Live Test Variables
  def get_dummy_odds do
    %{
      "2021/04/01/chwmlb-laamlb-1" => %{
        awayodds: 1.95,
        homeodds: 1.95,
        awayteam: "White Sox",
        hometeam: "Tigers",
        date: "2021-04-01"
      }
    }
  end

  def get_dummy_lineups do
    %{
      "2021/04/01/chwmlb-laamlb-1" => %{
        awaylineup: [
          "John Doe",
          "John Doe",
          "John Doe",
          "John Doe",
          "John Doe",
          "John Doe",
          "John Doe",
          "John Doe",
          "John Doe"
        ],
        awaypids: [
          100_000,
          100_000,
          100_000,
          100_000,
          100_000,
          100_000,
          100_000,
          100_000,
          100_000
        ],
        awaypitcher: ["Clayton Kershaw"],
        awaystarter: [600_000],
        awteam: "Cardinals",
        date: "2021-04-01",
        homelineup: [
          "John Doe",
          "John Doe",
          "John Doe",
          "John Doe",
          "John Doe",
          "John Doe",
          "John Doe",
          "John Doe",
          "John Doe"
        ],
        homepids: [
          100_000,
          100_000,
          100_000,
          100_000,
          100_000,
          100_000,
          100_000,
          100_000,
          100_000
        ],
        homepitcher: ["Trevor Bauer"],
        homestarter: [500_000],
        hmteam: "Mariners"
      }
    }
  end

  def get_dummy_schedule do
    %{
      "2021/04/01/chwmlb-laamlb-1" => %{
        batter: get_dummy_batter(),
        errors: get_dummy_errors(),
        gamedata: get_dummy_errors(),
        hits: get_dummy_hits(),
        linescore: get_dummy_linescore(),
        pitcher: get_dummy_pitcher(),
        status: get_dummy_status()
      }
    }
  end

  def get_dummy_preds do
    %{
      "2021/04/01/chwmlb-laamlb-1" => %{
        awayavg: 0.5,
        awayteam: "White Sox",
        awaywps: [0.5, 0.5, 0.5],
        homeavg: 0.5,
        hometeam: "Angels",
        homewps: [0.5, 0.5, 0.5],
        maxval: 0.5,
        minval: 0.5
      }
    }
  end

  defp get_dummy_status() do
    %{
      b: "2",
      ind: "I",
      inning: "6",
      inning_state: "Top",
      is_no_hitter: "N",
      is_perfect_game: "N",
      note: "",
      o: "2",
      reason: "",
      s: "3",
      status: "In Progress",
      top_inning: "Y"
    }
  end

  defp get_dummy_pitcher() do
    %{
      er: "0",
      era: "0.00",
      first: "Taylor",
      id: "642203",
      ip: "5.0",
      last: "Widener",
      losses: "0",
      name_display_roster: "Widener",
      number: "57",
      wins: "0"
    }
  end

  defp get_dummy_gamedata() do
    %{
      away_name_abbrev: "ARI",
      away_team_name: "D-backs",
      awayloss: "3",
      awayscore: "3",
      awaywins: "0",
      home_team_abbrev: "SD",
      home_team_name: "Padres",
      homescore: "0",
      homewins: "3",
      id: "2021/04/04/arimlb-sdnmlb-1",
      tipoff: "16:10"
    }
  end

  defp get_dummy_linescore() do
    %{
      "1" => %{awayscore: "1", homescore: "0"},
      "2" => %{awayscore: "1", homescore: "0"},
      "3" => %{awayscore: "1", homescore: "0"},
      "4" => %{awayscore: "1", homescore: "0"},
      "5" => %{awayscore: "1", homescore: "0"},
      "6" => %{awayscore: "1", homescore: "0"},
      "7" => %{awayscore: "1", homescore: "0"},
      "8" => %{awayscore: "1", homescore: "0"},
      "9" => %{awayscore: "1", homescore: "0"}
    }
  end

  defp get_dummy_errors() do
    %{
      away: "1",
      home: "0"
    }
  end

  defp get_dummy_hits() do
    %{
      away: "1",
      home: "0"
    }
  end

  defp get_dummy_batter() do
    %{
      ab: "1",
      avg: "0.329",
      first: "John",
      h: "1",
      hr: "1",
      id: "600000",
      last: "Doe",
      name_display_roster: "John Doe",
      number: "1",
      obp: ".500",
      ops: ".500",
      pos: "SS",
      rbi: "0",
      slg: ".750"
    }
  end

  def mdltypes do
    [
      MlbModel.LinearClsf,
      MlbModel.LogisticClsf,
      MlbModel.RandomForest,
      MlbModel.XGBoost,
      MlbModel.NeuralNet
    ]
  end

  def modelToString(mtype) do
    case mtype do
      MlbModel.LinearClsf -> "LinearClsf"
      MlbModel.LogisticClsf -> "LogisticClsf"
      MlbModel.RandomForest -> "RandomForest"
      MlbModel.XGBoost -> "XGBoost"
      MlbModel.NeuralNet -> "NeuralNet"
      MlbModel.Blend -> "Blend"
    end
  end

  def statcast_floats do
    [
      :sz_bot,
      :sz_top,
      :pfx_x,
      :pfx_z,
      :ax,
      :ay,
      :az,
      :release_pos_x,
      :release_pos_y,
      :release_pos_z,
      :vx0,
      :vy0,
      :vz0,
      :release_extension,
      :release_speed,
      :plate_x,
      :plate_z,
      :hc_x,
      :hc_y,
      :estimated_woba_using_speedangle,
      :launch_speed,
      :effective_speed,
      :estimated_ba_using_speedangle,
      :delta_run_exp,
      :delta_home_win_exp,
      :woba_value,
      :break_length_deprecated,
      :break_angle_deprecated,
      :spin_dir
    ]
  end

  def statcast_ints do
    [
      :balls,
      :strikes,
      :batter,
      :pitcher,
      :zone,
      :pitch_number,
      :at_bat_number,
      :release_spin_rate,
      :inning,
      :fielder_1,
      :fielder_2,
      :fielder_3,
      :fielder_4,
      :fielder_5,
      :fielder_6,
      :fielder_7,
      :fielder_8,
      :fielder_9,
      :on_1b,
      :on_2b,
      :on_3b,
      :woba_denom,
      :post_bat_score,
      :babip_value,
      :game_year,
      :away_score,
      :bat_score,
      :post_away_score,
      :iso_value,
      :fld_score,
      :spin_axis,
      :home_score,
      :launch_speed_angle,
      :launch_angle,
      :hit_distance_sc,
      :post_fld_score,
      :hit_location,
      :release_spin_rate,
      :outs_when_up,
      :post_home_score,
      :tfs_zulu_deprecated,
      :umpire,
      :spin_rate_deprecated
    ]
  end

  def atbat_legend() do
    [
      :gid,
      :abid,
      :pitcherid,
      :batterid,
      :strikes,
      :balls,
      :outs,
      :des,
      :event,
      :event_num,
      :away_team_runs,
      :home_team_runs,
      :ob1start,
      :ob2start,
      :ob3start,
      :ob1end,
      :ob2end,
      :ob3end,
      :numpitches,
      :runs,
      :p_throws,
      :b_height,
      :stand,
      :faction,
      :datenum,
      :battername,
      :pitchername
    ]
  end

  def get_dummy_ets() do
    ##########################
    ## Set up the :ets tables
    ########################## 
    tables = [
      :schedule,
      :predictions,
      :lineups,
      :odds
    ]

    Enum.each(tables, fn table ->
      :ets.new(table, [
        :set,
        :named_table,
        :public,
        read_concurrency: true,
        write_concurrency: true
      ])

      ## initialize slugs
      :ets.insert(table, {table |> Atom.to_string(), %{}})
    end)

    :ets.insert(:schedule, {"schedule", get_dummy_schedule()})
    :ets.insert(:predictions, {"predictions", get_dummy_preds()})
    :ets.insert(:lineups, {"lineups", get_dummy_lineups()})
    :ets.insert(:odds, {"odds", get_dummy_odds()})
  end

  def delete_dummy_ets() do
    :ets.delete(:schedule)
    :ets.delete(:lineups)
    :ets.delete(:predictions)
    :ets.delete(:odds)
  end

  def datestring_to_unix(date) do
    datestring = date <> " 00:00:00"
    {:ok, naive} = NaiveDateTime.from_iso8601(datestring)
    {:ok, datetime} = DateTime.from_naive(naive, "Etc/UTC")
    DateTime.to_unix(datetime)
  end

  def standardname(name) do
    case name do
      ## Yulieski Gurriel
      "Yulieski" -> "Yuli"
      ## Nate Lowe
      "Nate" -> "Nathaniel"
      _ -> name
    end
  end
end
