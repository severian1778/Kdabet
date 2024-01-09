defmodule GameServer do
  @moduledoc """
  Holds the State of a Crypto Candle Crash Game
  """
  use GenServer
  require Logger

  alias Phoenix.PubSub
  @crash_rate 0.1
  #############################
  # Client API
  #############################
  #############################
  def start_link(opts) do
    options = Map.get(opts, :opts)
    GenServer.start_link(__MODULE__, :ok, options)
  end

  def stop(), do: GenServer.call(self(), :stop)
  def get_state(), do: GenServer.call(__MODULE__, :getstate, 30_000)

  ##############################
  # SERVER CALLBACKS
  ##############################
  ##############################

  def init(:ok) do
    #################
    # Constants
    #################
    #    PubSub.subscribe(GameServer, "OKOKOKOK")
    # PubSub.subscribe(GameServer.PubSub, "OKOKOKOKOKOK")
    PubSub.subscribe(:gaming_pubsub, "game:candle_crash")

    config = %{
      born: DateTime.utc_now(),
      last_updated: 0,
      heartbeat: 0,
      date: Date.to_iso8601(DateTime.utc_now() |> DateTime.add(-7 * 3600, :second))
    }

    #################
    ## Crash State
    #################
    rng = %{
      number: Nx.tensor(0),
      ## tells the process when to crash
      ## We tell the game to crash at multipler of 1.0 plus some random number from the exponential distribution
      crash: 1 + Statistics.Distributions.Exponential.rand(1.0)
    }

    ## start the crash Game
    iterate_crash()

    {:ok, %{config: config, rng: rng}}
  end

  def handle_call(:getstate, _from, state), do: {:reply, state, state}
  def handle_call(:stop, _from, state), do: {:stop, :normal, :ok, state}

  def handle_info(:work, state) do
    ## bet multiplier always starts at one  -> exp(0)
    bet_multipler = Nx.exp(state.rng.number)

    newState = %{
      config: state.config,
      rng: %{state.rng | number: Nx.add(state.rng.number, Nx.tensor(@crash_rate))}
    }

    ############################
    ## Schedule a timeout
    #############################
    cond do
      Nx.exp(state.rng.number) |> Nx.to_number() > state.rng.crash ->
        ## game has crashed
        ## handle end of game
        ## Broadcast message to all clients subscribed
        PubSub.broadcast(
          :gaming_pubsub,
          "game:candle_crash",
          {:game_finished, "Game round has concluded"}
        )

        {:noreply, state}

      true ->
        ## Broadcast message to susbcribed clients
        PubSub.broadcast(:gaming_pubsub, "game:candle_crash", {:game_continues, newState})

        ## otherwise, continue on
        iterate_crash()
        {:noreply, newState}
    end
  end

  def handle_info({:game_continues, message}, state), do: {:noreply, state}

  def handle_info({:game_finished, message}, state) do
    ## response to when a game round has finished "crashes"
    Logger.info(message)
    {:noreply, state}
  end

  def iterate_crash() do
    Process.send_after(self(), :work, 1_000)
  end
end
