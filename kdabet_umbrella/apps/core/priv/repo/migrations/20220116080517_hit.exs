defmodule Core.Repo.Migrations.Hit do
  use Ecto.Migration

  def change do
    create table(:hits) do
      add :gid, :integer
      add :abid, :integer
      add :des, :string
      add :batter, :integer
      add :pitcher, :integer
      add :team, :string
      add :x, :float
      add :y, :float
      add :hardness, :string
      add :launchangle, :float
      add :launchspeed, :float
      add :trajectory, :string
      add :distance, :float
      add :inning, :integer
      add :istop, :boolean
    end
  end
end
