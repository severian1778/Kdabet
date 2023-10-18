defmodule Digits do
  @moduledoc """
  `Digits` is a genServer Process which holds a trained numeric detection model in the state.
  """
  use GenServer
  alias Digits.Model.AlphaNumeric

  #############################
  # Client API
  #############################
  #############################
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def stop(), do: GenServer.call(__MODULE__, :stop)
  def get_state(), do: GenServer.call(__MODULE__, :getstate, 5_000)
  def train_digitrec(), do: GenServer.cast(__MODULE__, :train_digitrec)
  def predict(path), do: GenServer.cast(__MODULE__, {:predict, path})
  ##############################
  # SERVER CALLBACKS
  ##############################
  ##############################

  def init(:ok) do
    #################
    # initial state
    #################
    config = %{
      born: DateTime.utc_now(),
      last_updated: 0,
      heartbeat: 0,
      date: Date.to_iso8601(DateTime.utc_now() |> DateTime.add(-8 * 3600, :second)),
      model: nil,
      params: nil
    }

    ## If the model is already pre-trained, load it,  otherwise train one up
    {model, params} =
      if File.exists?("priv/mnist.axon") do
        AlphaNumeric.load!()
      end

    ## scheduler
    {:ok, %{config | model: model, params: params}}
  end

  ## calls
  def handle_call(:getstate, _from, state), do: {:reply, state, state}
  def handle_call(:stop, _from, state), do: {:stop, :normal, :ok, state}

  ## predict the digit embeded in an image
  def handle_call({:predict, path}, _from, state) do
    ## Use Evision to construct a binary of the image to predict
    mat = Evision.imread(path, flags: Evision.Constant.cv_IMREAD_GRAYSCALE())
    mat = Evision.resize(mat, {28, 28})

    data =
      Evision.Mat.to_nx(mat)
      |> Nx.reshape({1, 28, 28})
      |> List.wrap()
      |> Nx.stack()
      |> Nx.backend_transfer()

    pred =
      state.model
      |> Axon.predict(state.params, data)
      |> Nx.argmax()
      |> Nx.to_number()

    {:reply, pred, state}
  end

  ## casts
  def handle_cast(:train_digitrec, state) do
    {model, params} = AlphaNumeric.run()
    {:noreply, %{state | model: model, params: params}}
  end
end
