defmodule AuthenticationBridge.Repo3.Migrations.Wallet do
  use Ecto.Migration

  def change do
    create table(:wallet, primary_key: true) do
      add(:username, :string)
      add(:pubkey, :string)
      add(:part3, :string)
    end
  end
end
