defmodule ScheduleTest do
  use ExUnit.Case
  doctest Schedule

  setup_all do
    {:ok,
     [
       schedule: Schedule.get_state(),
       api:
         Schedule.MlbClient.get(
           "/schedule/?sportId=1&date=#{Date.utc_today() |> Date.to_string()}"
         )
     ]}
  end

  test("Schedule genserver holding a struct?", state, do: assert(is_map(state[:schedule])))

  test "Can we connect to statsapi.mlb.com?", state do
    {:ok, res} = state[:api]
    assert res.status == 200
  end
end
