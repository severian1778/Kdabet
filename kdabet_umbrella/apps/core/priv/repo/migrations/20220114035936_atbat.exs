defmodule Core.Repo.Migrations.Atbat do
  use Ecto.Migration

  def change do
    create table(:atbats, primary_key: false) do
      add :id, :string, primary_key: true
      add :gid, :integer
      add :abid, :integer
      add :pitcherid, :integer
      add :batterid, :integer
      add :event, :string
      add :strikes, :integer
      add :balls, :integer
      add :outs, :integer
      add :des, :text
      add :away_team_runs, :integer
      add :home_team_runs, :integer
      add :inning, :integer
      add :errors, :integer
      add :istop, :boolean
      add :runs, :integer
      add :ob1start, :boolean
      add :ob2start, :boolean
      add :ob3start, :boolean
      add :ob1end, :boolean
      add :ob2end, :boolean
      add :ob3end, :boolean
      add :numpitches, :integer
      add :p_throws, :string
      add :stand, :string
      add :faction, :string
      add :datenum, :integer
      add :starttime, :string
      add :endtime, :string
    end

    create unique_index(:atbats, [:gid, :abid])  
  end
end
