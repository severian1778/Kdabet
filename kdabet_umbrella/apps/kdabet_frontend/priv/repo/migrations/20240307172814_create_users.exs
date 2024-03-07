defmodule KdabetFrontend.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :password, :string
      add :privatekey, :string
      add :publickey, :string

      timestamps()
    end
  end
end
