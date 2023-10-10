defmodule Core.Repo.Migrations.Runner do
  use Ecto.Migration

  def change do
    create table(:runners) do
      add :gid, :integer
      add :awayteam, :string
      add :hometeam, :string
      add :abid, :integer
      add :isout, :boolean
      add :start, :string
      add :end, :string
      add :originbase, :string
      add :outbase, :string
      add :player, :integer
    end

    create unique_index(:runners, [:abid]) 
  end
end
