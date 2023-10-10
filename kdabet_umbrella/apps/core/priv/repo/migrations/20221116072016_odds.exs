defmodule Core.Repo.Migrations.Odds do
  use Ecto.Migration
  def change do
    create table(:odds, primary_key: false) do
      add(:id, :string, primary_key: true)
      add(:gid, :integer)
      add(:awayml, :float)
      add(:homeml, :float)
      add(:awayteam, :string)
      add(:hometeam, :string)
    end
  end
end
