defmodule Schedules.NbaOfficialClient do
  use Tesla
  Application.ensure_all_started(:hackney)

  ## TESLA CONFIGURATION WITH PROXY
  # api_key = "c54849bfdd70d5193ebe154473fc72d6532dd123"
  # {:ok, _status, _header, body} = :hackney.get("https://api.getproxylist.com/proxy?apiKey=#{api_key}")
  # proxyobj = :hackney.body(body)|>elem(1)|>Jason.decode()|>elem(1)
  # @proxy {:https, proxyobj["ip"], proxyobj["port"], []}

  ## Middleware
  plug({Tesla.Middleware.BaseUrl, "https://stats.nba.com/stats"})

  plug(
    {Tesla.Middleware.Headers,
     [
       {"Host", "stats.nba.com"},
       {"Referer", "https://stats.nba.com"},
       {"User-Agent",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0"},
       {"x-nba-stats-origin", ~c"stats"},
       {"x-nba-stats-token", ~c"true"},
       {"Connection", ~c"keep-alive"},
       {"Accept", ~c"application/json, text/plain, */*"},
       {"Accept-Encoding", ~c"gzip, deflate, br"},
       {"Accept-Language", ~c"en-US, en;q=0.5"},
       {"Pragma", ~c"no-cache"},
       {"Cache-Control", ~c"no-cache"}
     ]}
  )

  plug(Tesla.Middleware.JSON)
  plug({Tesla.Middleware.Compression, format: "gzip"})

  # use Hackney
  # , proxy: @proxy)
  adapter(Tesla.Adapter.Hackney, recv_timeout: 30_000)
end
