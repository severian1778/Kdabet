defmodule KdabetFrontendWeb.Components.GameList do
  @moduledoc """
  An HTML snippet representing a wrapper for a dynamic list of games to render into.
  """
  use Surface.Component
  alias KdabetFrontendWeb.Components.{OddsPair}

  @doc "The list of currently chosen games"
  prop(gamelist, :list, required: true)

  @doc "The Game Menu Header"
  slot(gamelistheader)

  @doc "The Game Type Menu"
  slot(bettypemenu)

  def render(assigns) do
    ~F"""
    <div class="flex flex-col w-full">
      {!-- Header --}
      <#slot {@gamelistheader} />
      {!-- Bet Type Menu --}
      <div class="w-[90%] mx-auto mb-2 text-sm font-bold">
        <#slot {@bettypemenu} />
      </div>
      {!-- Betting Game List --}
      <div class="w-[90%] mx-auto my-4 rounded border border-4 border-slate-500">
        <div class="w-full py-1 px-3 bg-pink-600 border-b border-slate-700 font-bold bg-gradient-to-b from-[#1e0542] to-[#350d3f]">Today's Games ({@gamelist |> length})</div>
        <div class="w-full flex flex-row py-1 px-3 font-bold bg-slate-700 text-slate-300 text-xs">
          <div class="basis-1/4" />
          <div class="flex justify-end basis-1/4">
            <span class="w-[130px] text-center">Moneyline</span>
          </div>
          <div class="flex justify-end basis-1/4">
            <span class="w-[130px] text-center">Spread</span>
          </div>
          <div class="flex justify-end basis-1/4">
            <span class="w-[130px] text-center space-x-10">
              <span>Over</span><span>Under</span>
            </span>
          </div>
        </div>
        {#for game <- @gamelist}
          <div class="w-full px-3 flex flex-row border-b border-slate-600 bg-gradient-to-b from-[#091f36] to-[#1b3649] py-3">
            {!-- The Matchup --}
            <div class="basis-1/4 flex flex-col text-sm font-bold">
              <span>{game.awayteam}</span>
              <span>{game.hometeam}</span>
              <span class="text-xs">{game.starttime}</span>
            </div>
            {!-- Moneyline --}
            <OddsPair style="moneyline_button" game={game} odds={{2.000, 2.100}}>
              <:oddA>2.000</:oddA>
              <:oddB>2.100</:oddB>
            </OddsPair>
            {!-- Point Spread --}
            <OddsPair style="spread_button" game={game} odds={{2.000, 2.100}}>
              <:oddA><span>+1.5</span><span>2.000</span></:oddA>
              <:oddB><span>-1.5</span><span>2.100</span></:oddB>
            </OddsPair>
            {!-- Totals --}
            <OddsPair style="spread_button" game={game} odds={{2.000, 2.100}}>
              <:oddA><span>8.5</span><span>2.000</span></:oddA>
              <:oddB><span>8.5</span><span>2.100</span></:oddB>
            </OddsPair>
          </div>
        {/for}
      </div>
    </div>
    """
  end
end
