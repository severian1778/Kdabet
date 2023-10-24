defmodule KdabetFrontendWeb.Components.SportMenuItem do
  @moduledoc """
  An HTML snippet representing a wrapper for a dynamic list of games to render into.
  """
  use Surface.Component

  @doc "The Sport's Name"
  slot(sport)

  @doc "The Number of Games Badge"
  slot(cardinality)

  @doc "The Icon's Name"
  prop(sportname, :string, required: true)

  @doc "The Icon's Name"
  prop(iconname, :string, required: true)

  def render(assigns) do
    ~F"""
    <li
      class="flex flex-row justify-between"
      :on-click="sportmenuitem_click"
      phx-value-sport={@sportname}
    >
      <span class="flex flex-row justify-start space-x-2">
        <span class="self-center"><FontAwesome.LiveView.icon name={@iconname} type="solid" /></span>
        <span><#slot {@sport} /></span>
      </span>
      <#slot {@cardinality} />
    </li>
    """
  end
end

## :on-click="tokenslot_click" phx-target={@target} phx-value-index={@index} phx-value-pair={@token}
