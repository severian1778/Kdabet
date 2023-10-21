defmodule KdabetFrontendWeb.Components.GameList do
  @moduledoc """
  An HTML snippet representing a wrapper for a dynamic list of games to render into.
  """
  use Surface.Component

  @doc "The list of currently chosen games"
  prop(gamelist, :list, required: true)

  @doc "The Test Slot"
  slot(testslot)

  slot(default)

  def render(assigns) do
    ~F"""
    <div class="flex flex-col w-full">
      {!-- Header --}
      <div><#slot {@default} /></div>
      <hr/>
      {!-- Betting Game List --}
      {#for game <- @gamelist}
        <div class="flex flex-col">
          <span>{game.awayteam}</span>
          <span>{game.hometeam}</span>
        </div>
      {/for}
      <hr/>
      {!-- Footer --}
      <div><#slot {@testslot} /></div>
    </div>
    """
  end
end
