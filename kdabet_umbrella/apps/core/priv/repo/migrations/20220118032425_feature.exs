defmodule Core.Repo.Migrations.Feature do
  use Ecto.Migration

  def change do
    create table(:features) do    
      add :gid, :integer
      add :vector, {:array, :float}
      add :numab, :integer
    end    
  end
end
