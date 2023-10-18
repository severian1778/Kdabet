defmodule Odds do
  @moduledoc """
  Documentation for `Odds`.
  """

  def take_screenshot(url) do
    {:ok, session} =
      Wallaby.start_session()

    ## Start the Wallaby session
    session
    |> Wallaby.Browser.visit(url)

    ## Time out for a bit so the website can load
    :timer.sleep(5000)

    ## Take the screenshot and exit
    session
    |> Wallaby.Browser.take_screenshot([{:name, "testshot"}])
  end
end
