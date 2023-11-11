defmodule KdabetFrontendWeb.Components.OddsPair do
  @moduledoc """
  An HTML snippet which renders the buttons to choose a betting propostion.
  """
  use Surface.Component
  # alias Core.Types.{Bet}

  @doc "The slot for the odds"
  slot oddA

  @doc "The slot for the odds"
  slot oddB

  @doc "The button class"
  prop style, :string, required: true

  @doc "The button class"
  prop odds, :tuple, required: true

  @doc "The type of bet being made"
  prop bettype, :string, required: true

  @doc "The game object"
  prop game, :map, required: true

  def render(assigns) do
    ## TODO: find a better name for bettime -> "Full match bet, halves, quarters"
    ~F"""
    <div class="basis-1/4 flex flex-row justify-end space-x-5 self-center">
      {!-- render the button and adding data to send to event handler in the parent live view --}
      <button
        class={@style}
        :on-click="to_betslip"
        phx-value-bet={%{
          beton: @game.awayteam,
          odd: @odds |> elem(0),
          bettype: @bettype,
          bettime: "Game",
          league: @game.league,
          matchup: @game.awayteam <> " vs. " <> @game.hometeam,
          sport: @game.sport
        }
        |> Jason.encode!()}
      >
        <#slot {@oddA} />
      </button>
      <button
        class={@style}
        :on-click="to_betslip"
        phx-value-bet={%{
          beton: @game.hometeam,
          odd: @odds |> elem(0),
          bettype: @bettype,
          bettime: "Game",
          league: @game.league,
          matchup: @game.awayteam <> " vs. " <> @game.hometeam,
          sport: @game.sport
        }
        |> Jason.encode!()}
      >
        <#slot {@oddB} />
      </button>
    </div>
    """
  end
end

## :on-click="tokenslot_click" phx-target={@target} phx-value-index={@index} phx-value-pair={@token}
