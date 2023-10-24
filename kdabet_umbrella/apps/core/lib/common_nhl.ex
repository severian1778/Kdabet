defmodule Core.Common.Nhl do
  @moduledoc """
  Common functions for usage in NHL context
  """
  @doc """
  Function: fullname_to_abbr() -> Changes a full team name string to a into a team 3 letter abbreviation
  """
  @spec fullname_to_abbr(String.t()) :: String.t()
  def fullname_to_abbr(fullname) when is_binary(fullname) do
    case fullname do
      "Vegas Golden Knights" -> "VGK"
      "Philadelphia Flyers" -> "PHI"
      "Los Angeles Kings" -> "LAK"
      "Arizona Coyotes" -> "PHX"
      "Calgary Flames" -> "CGY"
      "New York Rangers" -> "NYR"
      "Vancouver Canucks" -> "VAN"
      "Nashville Predators" -> "NSH"
      "Minnesota Wild" -> "MIN"
      "Edmonton Oilers" -> "EDM"
      "St. Louis Blues" -> "STL"
      "Winnipeg Jets" -> "WPG"
      "Chicago Blackhawks" -> "CHC"
      "Boston Bruins" -> "BOS"
      "Detroit Red Wings" -> "DET"
      "Seattle Kraken" -> "SEA"
      "New York Islanders" -> "NYI"
      "Colorado Avalanche" -> "COL"
      "San Jose Sharks" -> "SJS"
      "Florida Panthers" -> "FLA"
      "Pittsburgh Penguins" -> "PIT"
      "Dallas Stars" -> "DAL"
      "Montréal Canadiens" -> "MTL"
      "New Jersey Devils" -> "NJD"
      "Carolina Hurricanes" -> "CAR"
      "Tampa Bay Lightning" -> "TBL"
      "Ottawa Senators" -> "OTT"
      "Buffalo Sabres" -> "BUF"
      "Columbus Blue Jackets" -> "CLB"
      "Anaheim Ducks" -> "ANA"
      "Washington Capitals" -> "WAS"
      "Toronto Maple Leafs" -> "TOR"
    end
  end
end
