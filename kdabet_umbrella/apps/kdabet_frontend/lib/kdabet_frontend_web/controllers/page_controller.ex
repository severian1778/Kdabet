defmodule KdabetFrontendWeb.PageController do
  use KdabetFrontendWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def about(conn, _params) do
    render(conn, :about, layout: false)
  end

  def demo(conn, _params) do
    render(conn, :demo, layout: false)
  end

  def kings(conn, _params) do
    render(conn, :kings, layout: false)
  end
end
