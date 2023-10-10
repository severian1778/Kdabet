defmodule MlbScheduleTest do
  use ExUnit.Case
  doctest MlbSchedule

  setup_all do
    {:ok,
     [
       schedule: MlbSchedule.get_state(),
       api:
         MlbSchedule.MlbClient.get(
           "/schedule/?sportId=1&date=#{Date.utc_today() |> Date.to_string()}"
         )
     ]}
  end

  test "greets the world", do: assert(MlbSchedule.hello() == :world)
  test("MlbSchedule genserver holding a struct?", state, do: assert(is_map(state[:schedule])))

  test "Can we connect to statsapi.mlb.com?", state do
    {:ok, res} = state[:api]
    assert res.status == 200
  end
end
