defmodule KdabetFrontendWeb.Demo do
  use KdabetFrontendWeb, :surface_live_view_book
  alias KdabetFrontendWeb.Components.{GameList, SportMenuItem}

  @impl true
  def mount(_params, _session, socket) do
    mlb_schedule =
      Schedules.get_official_mlb_data()
      |> Map.get(:gamemaps)
      |> Map.values()

    ## TODO: make this into a next 10 games coming up game list
    current_gamelist = dummy_gamelist()

    ## A list of sports and FontAwesome icon names tuples
    sportlist = [
      {"Football", "football"},
      {"Soccer", "futbol"},
      {"Baseball", "baseball"},
      {"Hockey", "hockey-puck"},
      {"Basketball", "basketball"},
      {"E-Sports", "gamepad"}
    ]

    {:ok,
     socket
     |> assign(id: socket.id)
     |> assign(current_gamelist: current_gamelist)
     |> assign(mlb_schedule: mlb_schedule)
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
          {#for {sportname, iconname} <- @sportlist}
            <SportMenuItem iconname={iconname} sportname={sportname}>
              <:sport>{sportname}</:sport>
            </SportMenuItem>
          {/for}
        </ul>

        <!-- Tablet and up Menu -->
        <ul class="nav_device border-t border-slate-700 hidden md:block">
          {#for {sportname, iconname} <- @sportlist}
            <SportMenuItem iconname={iconname} sportname={sportname}>
              <:sport>{sportname}</:sport>
            </SportMenuItem>
            <!--<li class="flex justify-items-start">
              <FontAwesome.LiveView.icon name={iconname} type="solid" class="navmenu_icon"/>
              <span>{sportname}</span>
            </li>-->
          {/for}
        </ul>
      </section>
      <!-- Main Menu -->
      <section class="basis-10/12 md:basis-8/12 lg:basis-6/12 md:border-l md:border-r">
        <GameList gamelist = {@current_gamelist}>
          <p>Brad is a nice guy.</p>
          <:testslot>Additional Data</:testslot>
        </GameList>
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
        _ -> dummy_gamelist()
      end

    {:noreply, assign(socket, current_gamelist: new_gamelist)}
  end

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
        seriesGameNumber: 4
      }
    ]
  end
end
