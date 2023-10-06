defmodule KdabetFrontendWeb.Components.CardTest do
  use KdabetFrontendWeb.ConnCase, async: true
  use Surface.LiveViewTest

  catalogue_test KdabetFrontendWeb.Card
end
