defmodule KdabetFrontendWeb.Components.CandleChart do
  @moduledoc """
  A stateful component that renders a Crypto Candle Chart
  """
  use Surface.LiveComponent

  ## slots
  slot(default)

  def render(assigns) do
    # Here we have the element that will load the embedded view. Special note to data-id which is the
    # identifier that will be used by the hooks to understand which socket sent want.

    # We also identify the hook that will use this component using phx-hook.
    # Refer again to https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks-via-phx-hook
    ~F"""
    <div class="graphcont" id="graph" phx-hook="VegaLite" phx-update="ignore" data-id={@id}/>
    """
  end
end
