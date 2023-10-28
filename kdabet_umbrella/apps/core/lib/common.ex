defmodule Core.Common do
  @moduledoc """
  Commmon functions applicable to all umbrella modules
  """

  @doc """
    Function => Pad Dates.
    - arity(0)
    - return <string>
  """
  @spec padint(integer()) :: binary()
  def padint(num) do
    num |> Integer.to_string() |> String.pad_leading(2, "0")
  end

  @doc """
  Replicates a value n times and returns a list of the replicated value
  """
  @spec replicate(integer(), any()) :: list(any())
  def replicate(n, x), do: for(_ <- 1..n, do: x)

  @doc """
  Handy method for adding up two lists of numbers
  iex(1)> arraysum([1,2,3],[1,2,3])
        return ->  [2,4,6]
  """
  @spec arraysum(list(integer() | float()), list(integer() | float())) ::
          list(integer() | float())
  def arraysum(to_add, list) when is_list(to_add) and is_list(list) do
    Enum.map(list |> Enum.with_index(), fn {feature, idx} ->
      feature + (to_add |> Enum.at(idx))
    end)
  end

  @doc """
  Parses a custom datetime string and returns a DateTime object.

  The input string should be in the format "Day, Month Dayth at HH:MM AM/PM TZ",
  where Month is the full month name, Day is the day of the month, HH is the hour (1-12),
  MM is the minute, AM/PM indicates morning or evening, and TZ is the time zone abbreviation.

  Example:
  iex> parse_custom_datetime_string("Fri, October 27th at 10:00 PM EDT")
  {:ok, #DateTime<2023-10-27T22:00:00Z>}

  iex> parse_custom_datetime_string("Tue, June 15th at 09:30 AM UTC")
  {:ok, #DateTime<2023-06-15T09:30:00Z>}

  iex> parse_custom_datetime_string("Invalid datetime format")
  {:error, "Invalid datetime format"}

  """

  @spec parse_custom_datetime_string(datetime_string :: String.t()) ::
          {:ok, DateTime.t()} | {:error, String.t()}
  def parse_custom_datetime_string(datetime_string) do
    # Define a map to convert month names to their numerical representation
    month_map = %{
      "January" => "01",
      "February" => "02",
      "March" => "03",
      "April" => "04",
      "May" => "05",
      "June" => "06",
      "July" => "07",
      "August" => "08",
      "September" => "09",
      "October" => "10",
      "November" => "11",
      "December" => "12"
    }

    # Split the input string into its components
    [_weekday, month_str, day_str, _at, time_str, am_pm, _tz] =
      String.split(datetime_string, ~r/\s+/)

    # Extract the month, day, and time components
    month = Map.get(month_map, month_str)
    day = Integer.parse(day_str) |> elem(0)
    [hour_str, minute_str] = String.split(time_str, ":")
    {hour, _} = Integer.parse(hour_str)
    {minute, _} = Integer.parse(minute_str)

    # Adjust the hour for AM/PM
    hour =
      case am_pm do
        "AM" when hour == 12 -> 0
        "AM" -> hour
        "PM" when hour == 12 -> 12
        "PM" -> hour + 12
      end

    # Convert the components to ISO 8601 format
    "2023-#{month}-#{day}T#{String.pad_leading(hour |> to_string, 2, "0")}:#{String.pad_leading(minute |> to_string, 2, "0")}:00Z"
    |> DateTime.from_iso8601()
  end
end
