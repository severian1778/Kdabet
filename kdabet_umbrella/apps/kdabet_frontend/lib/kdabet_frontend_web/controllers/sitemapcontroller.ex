defmodule KdabetFrontendWeb.SitemapController do
  use KdabetFrontendWeb, :controller
  alias KdabetFrontendWeb.Sitemap

  def index(conn, _params) do
    xml =
      """
      <?xml version="1.0" encoding="UTF-8"?>
      <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
      <url>
      <loc>https://kdabet.com/about</loc>
      <changefreq>never</changefreq>
      <priority>0.5</priority>
      </url>
      <url>
      <loc>https://kdabet.com/kings</loc>
      <changefreq>never</changefreq>
      <priority>0.3</priority>
      </url>
      <url>
      <loc>https://kdabet.com/mint</loc>
      <changefreq>never</changefreq>
      <priority>0.3</priority>
      </url>
      <url>
      <loc>https://kdabet.com/casino</loc>
      <changefreq>never</changefreq>
      <priority>0.3</priority>
      </url>

      <% end %>
      </urlset>
      """

    conn
    |> put_resp_content_type("text/xml")
    |> send_resp(200, xml)
  end
end
