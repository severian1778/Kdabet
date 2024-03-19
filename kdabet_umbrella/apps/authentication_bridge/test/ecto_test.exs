defmodule AuthenticationBridgeWeb.EctoTest do
  # Once the mode is manual, tests can also be async
  # ExUnit.Case, async:  false
  use ExUnit.Case, async: true

  test "Do Ecto Repos shut down?" do
    AuthenticationBridge.start_repos()
    Process.whereis(AuthenticationBridge.Repo1) == nil
    assert(true)
  end

  test "can they be brought back up?" do
    AuthenticationBridge.stop_repos()
    assert true
  end
end
