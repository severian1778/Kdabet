defmodule KdabetFrontend.Sitemap do
  alias KdabetFrontendWeb.{Endpoint, Router.Helpers}

  use Sitemap,
    compress: false,
    host: "https://kdabet.com",
    files_path: "priv/static/"

  def generate do
    create do
      add("/demo", priority: 0.5, changefreq: "yearly", expires: nil)
      add("/about", priority: 0.5, changefreq: "yearly", expires: nil)
      add("/kings", priority: 0.5, changefreq: "yearly", expires: nil)
      add("/mint", priority: 0.5, changefreq: "yearly", expires: nil)
      add("/casino", priority: 0.5, changefreq: "yearly", expires: nil)
    end

    ping()
  end
end

KdabetFrontend.Sitemap.generate()
