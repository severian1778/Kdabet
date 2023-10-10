defmodule MlbScheduleTest do
  use ExUnit.Case
  doctest MlbSchedule

  setup_all do
    {:ok, MlbSchedule.get_state()}
  end

  test "greets the world", do: assert(MlbSchedule.hello() == :world)
  test("MlbSchedule genserver holding a struct?", state, do: assert(is_map(state)))
end
