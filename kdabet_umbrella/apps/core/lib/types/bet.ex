defmodule Core.Types.Bet do
  @moduledoc """
  Defines a data structure for a bet in the betslip
  """

  @type beton :: String.t()
  @type odd :: float()
  @type bettype :: String.t()
  @type bettime :: String.t()
  @type league :: String.t()
  @type matchup :: String.t()
  @type sport :: String.t()

  @type t :: %__MODULE__{
          beton: beton(),
          odd: odd(),
          bettype: bettype(),
          bettime: bettime(),
          league: league(),
          matchup: matchup(),
          sport: sport()
        }

  # defstruct [:hash, :sigs, :cmd]
  defstruct [:beton, :odd, :bettype, :bettime, :league, :matchup, :sport]

  def new(args) when is_list(args) do
    beton = Keyword.get(args, :beton)
    odd = Keyword.get(args, :odd)
    bettype = Keyword.get(args, :bettype)
    bettime = Keyword.get(args, :bettime)
    league = Keyword.get(args, :league)
    matchup = Keyword.get(args, :matchup)
    sport = Keyword.get(args, :sport)

    # with {:ok, hash} <- validate_hash(hash),
    #     {:ok, sigs} <- validate_sigs(sigs),
    #     {:ok, cmd} <- validate_cmd(cmd) do
    %__MODULE__{
      beton: beton,
      odd: odd,
      bettype: bettype,
      bettime: bettime,
      league: league,
      matchup: matchup,
      sport: sport
    }

    # end
  end

  def new(_args), do: {:error, [command: :not_a_list]}
end
