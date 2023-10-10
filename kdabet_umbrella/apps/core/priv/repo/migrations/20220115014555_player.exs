defmodule Core.Repo.Migrations.Player do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :pid, :integer, primary_key: true
      add :firstname, :string
      add :lastname, :string
    end
  end
end
