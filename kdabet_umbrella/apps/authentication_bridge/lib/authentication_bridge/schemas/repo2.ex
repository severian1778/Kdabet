defmodule AuthenticationBridge.Part2 do
  import Ecto.Changeset
  use Ecto.Schema

  schema "wallet" do
    field(:username, :string)
    field(:pubkey, :string)
    field(:part2, :string)
  end
end
