defmodule KdabetFrontendWeb.SitemapController do
  use KdabetFrontendWeb, :controller

  def index(conn, _params) do
    conn
    |> put_resp_content_type("text/xml")
    |> send_resp(
      200,
      """
      <?xml version=\"1.0\" encoding=\"UTF-8\"?>
      <urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">
      <url>
      <loc>https://kdabet.com/about</loc>
      <changefreq>never</changefreq>
      </url>
      <url>
      <loc>https://kdabet.com/kings</loc>
      <changefreq>never</changefreq>
      </url>
      <url>
      <loc>https://kdabet.com/mint</loc>
      <changefreq>never</changefreq>
      </url>
      <url>
      <loc>https://kdabet.com/casino</loc>
      <changefreq>never</changefreq>
      </url>
      </urlset>
      """
    )
  end
end
