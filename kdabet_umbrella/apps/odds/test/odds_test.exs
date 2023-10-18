defmodule OddsTest do
  use ExUnit.Case
  doctest Odds

  test "greets the world" do
    assert Odds.hello() == :world
  end
end
