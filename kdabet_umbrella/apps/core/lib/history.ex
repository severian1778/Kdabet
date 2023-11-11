defmodule Core.History do
  ## TODO:  For some reason there is an error that randomly appears here saying Core.Schedule does not exist,  find out why.
  import Ecto.Query
  alias Core.{Schedule}

  ## typing
  @type date() :: String.t()

  @doc """
  Function => get_fixture
    - arity(2)
      => dataA <String>: A string representing a iso8601 date
      => dataB <String>: A string representing a iso8601 date
    - purpose:  get a list of games in a date range
    - return: Struct <%Schedule>

    ## Example

       iex> Core.History.get_schedule "2016-04-03","2016-04-04"
       iex> [%Core.Schedule{gid: ...}, %Core.Schedule{gid: ...}, ...]

  """
  @spec get_schedule(date(), date()) :: {list(%Core.Schedule{})}
  def get_schedule(dateA, dateB) do
    naiveA = NaiveDateTime.from_iso8601!(Enum.join([dateA, "T00:00:00.123Z"]))
    naiveB = NaiveDateTime.from_iso8601!(Enum.join([dateB, "T23:59:59.123Z"]))
    query = from(s in Core.Schedule, where: s.date >= ^naiveA and s.date <= ^naiveB)
    Core.Repo.all(query)
  end

  @spec get_schedule(date()) :: {list(%Core.Schedule{})}
  def get_schedule(date) when is_binary(date) do
    get_schedule(date, date)
  end

  def get_schedule(_) do
    {:error,
     "incorrect input format for get_schedule, please provide a datestring input -> `YYYY-MM-DD`"}
  end
end
