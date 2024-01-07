defmodule KdabetFrontendWeb.Casino do
  use KdabetFrontendWeb, :surface_live_view
  alias KdabetFrontendWeb.Components.{CandleChart}

  @impl true
  def mount(_params, _session, socket) do
    ## make the crash graph spec
    spec = create_chart_spec()
    IO.inspect(spec)
    ## return the assigns
    {:ok,
     socket
     |> assign(id: socket.id)
     |> push_event("vega_lite:#{socket.id}:init", %{"spec" => spec})}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <!-- Graph -->
    <span class="relative w-full h-fit">
      <CandleChart id={@id} />
    </span>
    """
  end

  defp create_chart_spec() do
    VegaLite.new()
    |> VegaLite.data_from_url("https://vega.github.io/editor/data/weather.csv")
    |> VegaLite.transform(filter: "datum.location == 'Seattle'")
    |> VegaLite.concat([
      VegaLite.new()
      |> VegaLite.mark(:bar)
      |> VegaLite.encode_field(:x, "date", time_unit: :month, type: :ordinal)
      |> VegaLite.encode_field(:y, "precipitation", aggregate: :mean),
      VegaLite.new()
      |> VegaLite.mark(:point)
      |> VegaLite.encode_field(:x, "temp_min", bin: true)
      |> VegaLite.encode_field(:y, "temp_max", bin: true)
      |> VegaLite.encode(:size, aggregate: :count)
    ])
    # Output the specifcation
    |> VegaLite.to_spec()
  end
end
