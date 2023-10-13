defmodule Schedules.MlbOfficialClient do
  use Tesla
  Application.ensure_all_started(:hackney)

  ## TESLA CONFIGURATION WITH PROXY
  api_key = "c54849bfdd70d5193ebe154473fc72d6532dd123"

  {:ok, _status, _header, body} =
    :hackney.get("https://api.getproxylist.com/proxy?apiKey=#{api_key}")

  proxyobj = :hackney.body(body) |> elem(1) |> Jason.decode() |> elem(1)
  @proxy {:https, proxyobj["ip"], proxyobj["port"], []}

  ## Middleware
  plug({Tesla.Middleware.BaseUrl, "https://statsapi.mlb.com/api/v1/"})
  plug(Tesla.Middleware.JSON)

  ## Use Hackney
  adapter(Tesla.Adapter.Hackney, recv_timeout: 30_000, proxy: @proxy)
end
