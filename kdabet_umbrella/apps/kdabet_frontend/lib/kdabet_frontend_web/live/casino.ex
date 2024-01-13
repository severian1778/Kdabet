defmodule KdabetFrontendWeb.Casino do
  use KdabetFrontendWeb, :surface_live_view
  alias KdabetFrontendWeb.Components.{CandleChart}
  alias GameServer

  @impl true
  def mount(_params, _session, socket) do
    # make the crash graph spec
    Phoenix.PubSub.subscribe(:gaming_pubsub, "game:candle_crash")

    spec = create_chart_spec()
    ## return the assigns
    {
      :ok,
      socket
      |> assign(id: socket.id)
      |> assign(data: [])
      |> push_event("vega_lite:#{socket.id}:init", %{"spec" => spec})
    }
  end

  @impl true
  def render(assigns) do
    ~F"""
    <!-- Graph -->
    <span class="relative w-full h-fit">
      <CandleChart id={@id} :on-click="restart"/>
    </span>
    """
  end

  defp create_chart_spec(data \\ []) do
    VegaLite.new(title: "Candle Crash", width: :container, height: 250, padding: 5)
    # Load values. Values are a map with the attributes to be used by Vegalite
    |> VegaLite.data_from_values(data)
    # Defines the type of mark to be used
    |> VegaLite.mark(:line)
    # Sets the axis, the key for the data and the type of data
    |> VegaLite.encode_field(:x, "time", type: :nominal)
    |> VegaLite.encode_field(
      :y,
      "total",
      type: :quantitative,
      scale: [zero: false, domain_max: 5, domain_min: 0]
    )
    # Output the specifcation
    |> VegaLite.to_spec()
  end

  def fake_data do
    today = Date.utc_today()
    until = today |> Date.add(10)

    Enum.map(Date.range(today, until), fn date ->
      %{total: Enum.random(1..100), time: Date.to_iso8601(date), name: "potato"}
    end)
  end

  @impl true
  def handle_info({:game_continues, message}, socket) do
    time =
      DateTime.from_naive!(DateTime.now!("Etc/UTC"), "Etc/UTC")
      |> Calendar.strftime("%y-%m-%d %I:%M:%S %p")
      |> String.split(" ")
      |> Enum.at(1)

    data =
      socket.assigns.data ++
        [%{name: "potato", total: message.rng.number |> Nx.exp() |> Nx.to_number(), time: time}]

    spec = create_chart_spec(data)

    {:noreply,
     socket
     |> assign(data: data)
     |> push_event("vega_lite:#{socket.id}:init", %{"spec" => spec})}
  end

  @impl true
  def handle_info({:game_finished, _message}, state) do
    ## response to when a game round has finished "crashes"
    {:noreply, state}
  end

  @impl true
  def handle_event("restart", _, socket) do
    GenServer.stop(GameServer)
    spec = create_chart_spec()

    {:noreply,
     socket
     |> assign(data: [])
     |> push_event("vega_lite:#{socket.id}:init", %{"spec" => spec})}
  end
end
