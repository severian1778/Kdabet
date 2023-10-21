defmodule KdabetFrontendWeb.Layouts do
  use KdabetFrontendWeb, :html

  embed_templates "layouts/*"
  embed_sface "layouts/root.sface"
  embed_sface "layouts/app.sface"
  embed_sface "layouts/book.sface"
end
