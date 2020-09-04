defmodule Weather.Parallel do
  def pmap(collection, fun) do
    collection
    |> Enum.map(&new_process(&1, self(), fun))
    |> Enum.map(&print/1)
  end

  def pmap2(collection, module, fun) do
    collection
    |> Enum.map(&Task.async(module, fun, [&1]))
    |> Enum.map(&Task.await/1)
  end

  ## Funciones privadas

  defp new_process(item, parent, fun) do
    spawn_link(fn ->
      send(parent, {self(), fun.(item)})
    end)
  end

  defp print(item) do
    receive do
      {^item, result} -> result
    end
  end
end
