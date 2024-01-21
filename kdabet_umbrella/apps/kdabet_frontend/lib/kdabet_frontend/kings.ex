defmodule KdabetFrontend.Kings do
  use GenServer

  alias KdabetFrontend.Kings.Transactions
  #############################
  # Client API
  #############################
  #############################

  @moduledoc """
  The Kings module tracks the state of the king.
  """
  def start_link(opts) do
    options = Map.get(opts, :opts)
    GenServer.start_link(__MODULE__, :ok, options)
  end

  def stop(), do: GenServer.call(self(), :stop)
  def get_state(), do: GenServer.call(__MODULE__, :getstate, 30_000)

  def get_king(address) do
    GenServer.call(__MODULE__, {:getking, address})
  end

  def get_kings() do
    GenServer.call(__MODULE__, :getkings)
  end

  def poll_kings() do
    GenServer.cast(__MODULE__, :pollkings)
  end

  ##############################
  # SERVER CALLBACKS
  ##############################
  ##############################

  def init(:ok) do
    {kings, _binding} = Code.eval_file("priv/static/kingsdata.txt")
    #################
    # Constants
    #################
    config = %{
      born: DateTime.utc_now(),
      last_updated: 0,
      heartbeat: 0,
      date: Date.to_iso8601(DateTime.utc_now() |> DateTime.add(-7 * 3600, :second)),
      kings: kings,
      minted: Enum.map(kings, fn _k -> false end)
    }

    __MODULE__.poll_kings()
    {:ok, config}
  end

  def handle_call({:getking, address}, _from, state) do
    kingdata =
      Enum.filter(state.kings, fn k ->
        k |> elem(0) == address
      end)
      |> List.first()

    {:reply, kingdata, state}
  end

  def handle_call(:getkings, _from, state) do
    {:reply, state.kings, state}
  end

  def handle_call(:getstate, _from, state), do: {:reply, state, state}
  def handle_call(:stop, _from, state), do: {:stop, :normal, :ok, state}

  def handle_cast(:pollkings, state) do
    ## we enumerate throught he kings and update the state for is minted status
    minted =
      Enum.map(state.kings, fn king ->
        account = king |> elem(0)

        {:ok, response} =
          Transactions.has_minted(account)

        response.result
        |> Map.get(:data)
      end)

    {:noreply, %{state | minted: minted}}
  end
end
