defmodule Core.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uid, :string, []}
  schema "bet" do
    field(:amount, :float)
    field(:towin, :float)
    field(:beton, :string)
  end

  def changeset(schedule, params \\ %{}) do
    schedule
    |> cast(params, [
      :uid,
      :amount,
      :beton
    ])
  end
end
