defmodule KdabetFrontendWeb.Demo do
  use KdabetFrontendWeb, :surface_live_view_book
  alias KdabetFrontendWeb.Components.{GameList, SportMenuItem}

  @impl true
  def mount(_params, _session, socket) do
    ## Gathering all of the scheduled betting markets
    mlb_schedule =
      Schedules.get_official_mlb_data()
      |> Map.get(:gamemaps)
      |> Map.values()

    nba_schedule =
      Schedules.get_official_nba_data()
      |> Map.get(:gamemaps)
      |> Map.values()

    nhl_schedule =
      Schedules.get_official_nhl_data()
      |> Map.get(:gamemaps)
      |> Map.values()

    ## TODO: make this into a next 10 games coming up game list
    ## Initialize critical data for assigns
    current_gamelist = dummy_gamelist()
    current_market_type = "Next10"
    ## A list of sports and FontAwesome icon names tuples
    sportlist = [
      {"Football", "football", 0},
      {"Soccer", "futbol", 0},
      {"Baseball", "baseball", mlb_schedule |> length},
      {"Hockey", "hockey-puck", nhl_schedule |> length},
      {"Basketball", "basketball", nba_schedule |> length},
      {"E-Sports", "gamepad", 0}
    ]

    {:ok,
     socket
     |> assign(id: socket.id)
     |> assign(current_gamelist: current_gamelist)
     |> assign(current_market_type: current_market_type)
     |> assign(mlb_schedule: mlb_schedule)
     |> assign(nba_schedule: nba_schedule)
     |> assign(nhl_schedule: nhl_schedule)
     |> assign(sportlist: sportlist)}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <div class="book_main flex flex-col md:flex-row text-slate-200">
      <!-- Traditional 3-column menu collapsing into a 2 column tablet ux and a columnar mobile UX -->
      <!-- Navigation -->
      <section class="navmenu glassy_bg basis-2/12 md:basis-4/12 lg:basis-3/12 border-b md:border-b-0">
        <!-- Mobile Menu -->
        <ul class="nav_mobile block md:hidden text-sm w-full flex flex-row align-items h-full">
          {#for {sportname, iconname, numgames} <- @sportlist}
            <SportMenuItem iconname={iconname} sportname={sportname}>
              <:sport>{sportname}</:sport>
              <:cardinality>
                <span class="rounded-full bg-slate-800 text-slate-200 h-7 w-7 text-sm border-2 border-slate-500 text-center leading-[1.5rem]">{numgames}</span>
              </:cardinality>
            </SportMenuItem>
         {/for}
        </ul>

        <!-- Tablet and up Menu -->
        <ul class="nav_device border-t border-slate-700 hidden md:block">
          {#for {sportname, iconname, numgames} <- @sportlist}
            <SportMenuItem iconname={iconname} sportname={sportname}>
              <:sport>{sportname}</:sport>
              <:cardinality>
                <span class="rounded-full bg-slate-800 text-slate-200 h-7 w-7 text-sm border-2 border-slate-500 text-center leading-[1.5rem]">{numgames}</span>
              </:cardinality>
            </SportMenuItem>
          {/for}
        </ul>
      </section>
      <!-- Main Menu -->
      <section class="basis-10/12 md:basis-8/12 lg:basis-6/12 md:border-l md:border-r bg-[rgba(0,0,0,0.2)]">
        <GameList gamelist={@current_gamelist}>
          {!-- Game List Header --}
          <:gamelistheader>
            <div class="relative flex flex-col w-[90%] overflow-hidden mt-10 mb-5 mx-auto border border-4 border-slate-500 rounded bg-gradient-to-b from-[#091f36] to-[#1b3649]">
              <img class="absolute top-[-25px] right-[30px] h-[207px]" src={"images/"<>headerImage(@current_market_type)<>".png"}>
              {!-- Breadcrumbs --}
              <div class="text-base pt-3 px-5 space-x-1">
                <a class="font-semibold" href="#">Home</a><span>/</span><span>{@current_market_type}</span>
              </div>
              {!-- League --}
              <div class="text-2xl font-bold py-3 px-5">
                <span>{@current_market_type} Odds</span>
              </div>
              {!-- Market Time Menu --}
              <div class="border-t border-slate-700 bg-[rgba(0,0,0,0.25)] px-5 pb-3 relative z-10]">
                <ul class="flex flex-row justify-start pt-4 px-2 space-x-3 text-sm">
                  <li class="hover:text-indigo-300"><a href="#">All</a></li>
                  <li class="hover:text-indigo-300"><a href="#">Today</a></li>
                  <li class="hover:text-indigo-300"><a href="#">Tomorrow</a></li>
                </ul>
              </div>
            </div>
          </:gamelistheader>
          {!-- Bet Type Menu --}
          <:bettypemenu>
            <ul class="flex flex-row justify-start space-x-3 indent-1">
              <li class="hover:text-indigo-300"><a href="#">Game</a></li>
              <li class="hover:text-indigo-300"><a href="#">1st Half</a></li>
            </ul>
          </:bettypemenu>
        </GameList>
        {!-- Resources Footer --}
        <div class="w-[90%] mx-auto my-5">
          <h1 class="text-2xl">{@current_market_type} Betting Resources</h1>
          <p class="py-2">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
        </div>
      </section>
      <!-- Bet Slip -->
      <section class="basis-3/12 hidden lg:block border-r">
        <p>BetSlip</p>
      </section>
    </div>
    """
  end

  @doc """
  Handle the changing of betting menu via clicking on a type of sport
  """
  @impl true
  def handle_event("sportmenuitem_click", %{"sport" => sport_str}, socket) do
    new_gamelist =
      case sport_str do
        "Baseball" -> socket.assigns.mlb_schedule
        "Basketball" -> socket.assigns.nba_schedule
        "Hockey" -> socket.assigns.nhl_schedule
        _ -> dummy_gamelist()
      end

    {:noreply, assign(socket, current_gamelist: new_gamelist, current_market_type: sport_str)}
  end

  ## returns the name of the header image dependant on the current sport in assigns
  defp headerImage(sport) do
    case sport do
      "Baseball" -> "baseballplayer"
      "Basketball" -> "basketballplayer"
      _ -> "baseballplayer"
    end
  end

  ## creates a dummy game list for display in the game list section
  defp dummy_gamelist() do
    [
      %{
        status: "Pre-Game",
        awayscore: 0,
        awayteam: "Philadelphia Corkscrews",
        homescore: 0,
        hometeam: "Arizona Peppermills",
        awayabbr: "phi",
        awayloss: 1,
        awaywins: 2,
        game_pk: 748_544,
        gametime: "Preview",
        homeabbr: "ari",
        homeloss: 2,
        homewins: 1,
        starttime: "17:05 pm ET"
      },
      %{
        status: "Pre-Game",
        awayscore: 0,
        awayteam: "New York Bongo Drummers",
        homescore: 0,
        hometeam: "Boston Bruisers",
        awayabbr: "nyy",
        awayloss: 1,
        awaywins: 2,
        game_pk: 748_544,
        gametime: "Preview",
        homeabbr: "bos",
        homeloss: 2,
        homewins: 1,
        starttime: "17:05 pm ET"
      }
    ]
  end
end
