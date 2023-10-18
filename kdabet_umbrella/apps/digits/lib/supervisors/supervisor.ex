defmodule Digits.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    IO.inspect :ok
    children = [
      {Digits, name: Digits},
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
