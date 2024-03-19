defmodule AuthenticationBridge.Part1 do
  import Ecto.Changeset
  use Ecto.Schema

  schema "wallet" do
    field(:username, :string)
    field(:pubkey, :string)
    field(:part1, :string)
  end
end
