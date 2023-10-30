defmodule KdabetFrontendWeb.Components.OddsPair do
  @moduledoc """
  An HTML snippet which renders the buttons to choose a betting propostion.
  """
  use Surface.Component

  @doc "The slot for the odds"
  slot oddA

  @doc "The slot for the odds"
  slot oddB

  @doc "The button class"
  prop style, :string, required: true

  @doc "The button class"
  prop odds, :tuple, required: true

  @doc "The game object"
  prop game, :map, required: true

  def render(assigns) do
    ~F"""
    <div class="basis-1/4 flex flex-row justify-end space-x-5 self-center">
      <button
        class={@style}
        :on-click="to_betslip"
        phx-value-beton={@game.awayteam}
        phx-value-odd={@odds |> elem(0)}
      >
        <#slot {@oddA} />
      </button>
      <button
        class={@style}
        :on-click="to_betslip"
        phx-value-beton={@game.hometeam}
        phx-value-odd={@odds |> elem(1)}
      >
        <#slot {@oddB} />
      </button>
    </div>
    """
  end
end

## :on-click="tokenslot_click" phx-target={@target} phx-value-index={@index} phx-value-pair={@token}
