defmodule Digits.Model.AlphaNumeric do
  @moduledoc """
  The Model Module contains the functions to trains and generate
  a standard alphanumeric prediction.
  """

  require Axon

  @batch_size 32
  ## percentage of validation data to cut off training set.  Must be >0.0 and <1.0
  @validation 0.2

  def run() do
    ## fetch the MNIST data
    {images, labels} = __MODULE__.download()

    ## batch the images and labels and zip it up into tuples
    images =
      images
      |> __MODULE__.transform_images()
      |> Nx.to_batched(@batch_size)
      |> Enum.to_list()

    labels =
      labels
      |> __MODULE__.transform_labels()
      |> Nx.to_batched(@batch_size)
      |> Enum.to_list()

    data = Enum.zip(images, labels)

    ## Split the data set into a traning data set and validation data set
    ## first by determining the index to slice on and then slicing it
    training_count = floor((1 - @validation) * Enum.count(data))
    validation_count = floor(@validation * training_count)

    {train, test_data} = Enum.split(data, training_count)
    {validation_data, training_data} = Enum.split(train, validation_count)

    ## Create Digit Recognition Model
    model = __MODULE__.create_model({1, 28, 28})
    Mix.Shell.IO.info("training...")
    state = __MODULE__.train_model(model, training_data, validation_data)
    Mix.Shell.IO.info("testing...")
    __MODULE__.test(model, state, test_data)

    ## Save Model
    __MODULE__.save!(model, state)

    ## Return the model and parameters
    {model, state}
  end

  @doc """
  Transforms image binaries into tensors.
  """
  def transform_images({binary, type, shape}) do
    binary
    |> Nx.from_binary(type)
    |> Nx.reshape(shape)
    |> Nx.divide(255)
  end

  @doc """
  Transforms target binaries into one hot encoded label tensors.
  """
  def transform_labels({binary, type, _}) do
    binary
    |> Nx.from_binary(type)
    |> Nx.new_axis(-1)
    |> Nx.equal(Nx.tensor(Enum.to_list(0..9)))
  end

  @doc """
  Decribes a neural architecture and returns it.
  """
  def create_model({channels, height, width}) do
    Axon.input("input_0", shape: {nil, channels, height, width})
    |> Axon.flatten()
    |> Axon.dense(128, activation: :relu)
    |> Axon.dense(10, activation: :softmax)
  end

  @doc """
  Trains a model and returns the parameters
  """
  def train_model(model, training_data, validation_data) do
    model
    |> Axon.Loop.trainer(:categorical_cross_entropy, Axon.Optimizers.adam(0.01))
    |> Axon.Loop.metric(:accuracy, "Accuracy")
    |> Axon.Loop.validate(model, validation_data)
    |> Axon.Loop.run(training_data, %{}, compiler: EXLA, epochs: 2)
  end

  @doc """
  Tests a model on unseen test data and returns its evaluations
  """
  def test(model, state, test_data) do
    model
    |> Axon.Loop.evaluator()
    |> Axon.Loop.metric(:accuracy, "Accuracy")
    |> Axon.Loop.run(test_data, state)
  end

  ## Save, fetch and load data.

  def download do
    Scidata.MNIST.download()
  end

  def save!(model, state) do
    contents = Axon.serialize(model, state)

    File.write!(path(), contents)
  end

  def load! do
    path()
    |> File.read!()
    |> Axon.deserialize()
  end

  ## Private Functions
  defp path do
    Path.join(Application.app_dir(:digits, "priv"), "mnist.axon")
  end
end
