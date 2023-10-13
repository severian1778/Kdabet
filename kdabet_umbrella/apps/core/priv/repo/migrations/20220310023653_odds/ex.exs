defmodule :"Elixir.Core.Repo.Migrations.Odds.ex" do
  use Ecto.Migration

  def change do
    create table(:atbats) do
      add :gid, :string
      add :awayteam, :string
      add :hometeam, :string
      add :awayml, :float
      add :homeml, :float
    end 
  end
end
