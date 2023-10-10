defmodule Core.Repo.Migrations.Sim do
  use Ecto.Migration

  def change do
    create table(:sims) do
      add :gid, :string
      add :mtype, :string
      add :abpit, :integer
      add :abbat, :integer
      add :abrlf, :integer
      add :traina, :string 
      add :trainb, :string 
      add :date, :naive_datetime
      add :return, :float 
      add :awaybe, :float
      add :homebe, :float
      add :awayimp, :float
      add :homeimp, :float
      add :awayteam, :string
      add :hometeam, :string
      add :awayscore, :integer
      add :homescore, :integer
      add :runs_earned, :integer
      add :edge, :float
      add :awaywps, {:array, :float}
      add :homewps, {:array, :float}
    end
  end
end
