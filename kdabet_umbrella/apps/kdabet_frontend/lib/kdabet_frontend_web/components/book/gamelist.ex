defmodule KdabetFrontendWeb.Components.GameList do
  @moduledoc """
  An HTML snippet representing a wrapper for a dynamic list of games to render into.
  """
  use Surface.Component

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
            <div class="basis-1/4 flex flex-row justify-end space-x-5 self-center">
              <button class="ring-offset-4 ring-stone-600 rounded ring p-1 h-10 w-14 text-slate-200 bg-slate-500 hover:bg-slate-700">2.000</button>
              <button class="ring-offset-4 ring-stone-600 rounded ring p-1 h-10 w-14 text-slate-200 bg-slate-500 hover:bg-slate-700">2.000</button>
            </div>
            {!-- Point Spread --}
            <div class="basis-1/4 flex flex-row justify-end space-x-5 self-center">
              <button class="flex flex-col ring-offset-4 ring-stone-600 rounded ring p-1 h-10 w-14 text-slate-200 bg-slate-500 hover:bg-slate-700">
                <span class="font-bold text-xs w-full text-center">-1.5</span>
                <span class="text-sm w-full text-center">2.000</span>
              </button>
              <button class="flex flex-col ring-offset-4 ring-stone-600 rounded ring p-1 h-10 w-14 text-slate-200 bg-slate-500 hover:bg-slate-700">
                <span class="font-bold text-xs w-full text-center">+1.5</span>
                <span class="text-sm w-full text-center">2.000</span>
              </button>
            </div>
            {!-- Totals --}
            <div class="basis-1/4 flex flex-row justify-end space-x-5 self-center">
              <button class="flex flex-col ring-offset-4 ring-stone-600 rounded ring p-1 h-10 w-14 text-slate-200 bg-slate-500 hover:bg-slate-700">
                <span class="font-bold text-xs w-full text-center">-8.5</span>
                <span class="text-sm w-full text-center">2.000</span>
              </button>
              <button class="flex flex-col ring-offset-4 ring-stone-600 rounded ring p-1 h-10 w-14 text-slate-200 bg-slate-500 hover:bg-slate-700">
                <span class="font-bold text-xs w-full text-center">+8.5</span>
                <span class="text-sm w-full text-center">2.000</span>
              </button>
            </div>
          </div>
        {/for}
      </div>
    </div>
    """
  end
end
