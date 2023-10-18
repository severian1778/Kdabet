defmodule DigitsTest do
  use ExUnit.Case
  doctest Digits

  test "greets the world" do
    assert Digits.hello() == :world
  end
end
