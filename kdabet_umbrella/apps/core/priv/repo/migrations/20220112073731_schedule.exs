defmodule Core.Repo.Migrations.Schedule do
  use Ecto.Migration

  def change do
    create table(:schedule, primary_key: false) do
      add(:gid, :string, primary_key: true)
      add(:awayteam, :string)
      add(:hometeam, :string)
      add(:awayscore, :integer)
      add(:homescore, :integer)
      add(:awayrecord, :string)
      add(:homerecord, :string)
      add(:date, :naive_datetime)
      add(:starttime, :naive_datetime)
    end
  end
end
