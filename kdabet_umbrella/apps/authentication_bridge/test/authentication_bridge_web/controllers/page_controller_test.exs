defmodule AuthenticationBridgeWeb.PageControllerTest do
  use AuthenticationBridgeWeb.ConnCase
  # Once the mode is manual, tests can also be async
  # ExUnit.Case, async:  false
  use ExUnit.Case, async: true

  test "Does Postgres shut down?" do
    Supervisor.stop(AuthenticationBridge.Repo1)

    (Process.whereis(AuthenticationBridge.Repo1) == nil)
    |> assert
  end
end
