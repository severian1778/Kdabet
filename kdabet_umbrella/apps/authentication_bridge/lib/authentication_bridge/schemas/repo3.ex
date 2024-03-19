defmodule AuthenticationBridge.Part3 do
  import Ecto.Changeset
  use Ecto.Schema

  schema "wallet" do
    field(:username, :string)
    field(:pubkey, :string)
    field(:part3, :string)
  end
end
