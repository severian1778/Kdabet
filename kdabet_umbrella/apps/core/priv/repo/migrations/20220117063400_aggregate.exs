defmodule Core.Repo.Migrations.Aggregate do
  use Ecto.Migration

  def change do
    create table(:aggregates) do    
      add :pid, :integer
      add :date, :naive_datetime 
      add :gid, :integer
      add :team, :string
      add :type, :string
      add :numab, :integer
      add :strikeouts, :integer
      add :homeruns, :integer
      add :singles, :integer
      add :doubles, :integer
      add :triples, :integer
      add :hbp, :integer
      add :walks, :integer
      add :groundouts, :integer
      add :forceouts, :integer
      add :flyouts, :integer
      add :popouts, :integer
      add :lineouts, :integer
      add :dps, :integer
      add :sacflys, :integer
      add :runs, :integer
      add :strikes, :integer
      add :balls, :integer
      add :pm, :integer
      add :oppsides, :integer
      add :samesides, :integer
      add :errors, :integer
      add :firstpitchstrikes, :integer
      add :fastballs, :integer
      add :fullcounts, :integer
      add :swingingstrikes, :integer
      add :calledstrikes, :integer
      add :hangers, :integer
      add :lows, :integer
      add :belows, :integer
      add :highs, :integer
      add :fouls, :integer
    end 
  end
end
