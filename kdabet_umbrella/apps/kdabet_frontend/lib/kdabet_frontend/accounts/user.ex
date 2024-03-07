defmodule KdabetFrontend.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  ## here we are using the library fields module FIelds.Password to encrypt columns in postgres
  schema "users" do
    field(:name, :string)
    field(:password, Fields.Password)
    field(:privatekey, Fields.Password)
    field(:publickey, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :password, :privatekey, :publickey])
    |> validate_required([:name, :password, :privatekey, :publickey])
  end
end
