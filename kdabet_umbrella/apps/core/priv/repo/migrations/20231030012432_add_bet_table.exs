defmodule Core.Repo.Migrations.AddBetTable do
  use Ecto.Migration

  def change do
    create table(:bet, primary_key: false) do
      add(:gid, :string, primary_key: true)
      add(:amount, :float)
      add(:beton, :string)
    end
  end
end
