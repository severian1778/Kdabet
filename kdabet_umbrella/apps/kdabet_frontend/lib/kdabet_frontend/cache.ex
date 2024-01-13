defmodule KdabetFrontend.Kings.Cache do
  @table_name :kings

  def start_link(opts \\ []) do
    Task.start_link(fn ->
      {:ok, _} =
        :dets.open_file(
          opts[:table_name] || @table_name,
          [{:auto_save, :timer.seconds(1)} | opts]
        )

      Process.hibernate(Function, :identity, [nil])
    end)
  end

  def get(table_name \\ @table_name, key) do
    case :dets.lookup(table_name, key) do
      [{^key, value}] -> {:ok, value}
      [] -> {:ok, nil}
    end
  end

  def put(table_name \\ @table_name, key, value) do
    :dets.insert(table_name, {key, value})
  end
end
