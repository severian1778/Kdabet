defmodule Core do
  @moduledoc """
  Documentation for `Core`.
  """
  import Ecto.Query
  alias Core.Repo

  @type date() :: String.t()
  @type gid() :: String.t()

  @doc """
  Function => delete_schedule/1
    - arity(1)
      => gid <String>: a string representing a game id
    - purpose:  delete a schedule entry
    - return: :ok

    ## Example
       iex> Core.delete_schedule("2016-04-03")
       iex> {:ok, "games for 2016-04-03 deleted"}

  """
  @spec delete_schedule(gid()) :: :atom
  def delete_schedule(gid) when is_binary(gid) do
    query =
      from(a in Core.Schedule,
        where: a.gid == ^gid
      )

    Repo.delete_all(query)

    :ok
  end

  def hello(), do: :world
end
