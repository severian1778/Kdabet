defmodule Core.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:gid, :string, []}
  schema "schedule" do
    field(:awayteam, :string)
    field(:hometeam, :string)
    field(:awayscore, :integer)
    field(:homescore, :integer)
    field(:awayrecord, :string)
    field(:homerecord, :string)
    field(:date, :naive_datetime)
    field(:starttime, :naive_datetime)
  end

  def changeset(schedule, params \\ %{}) do
    schedule
    |> cast(params, [
      :gid,
      :awayteam,
      :hometeam,
      :awayscore,
      :homescore,
      :awayrecord,
      :homerecord,
      :date,
      :starttime
    ])
    |> unique_constraint([:gid])
  end
end
