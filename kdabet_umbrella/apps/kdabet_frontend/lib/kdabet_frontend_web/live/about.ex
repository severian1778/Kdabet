defmodule KdabetFrontendWeb.About do
  use KdabetFrontendWeb, :surface_live_view

  def render(assigns) do
    ~F"""
    <div class="flex justify-center mt-12">
      <p class="text-pink-200">Big Test</p>
    </div>
    """
  end
end
