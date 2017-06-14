defmodule Weather.Parallel do

  def pmap(collection, fun) do
    collection
    |> Enum.map(&new_process(&1, self, fun))
    |> Enum.map(&print/1)
  end

  def new_process(item, parent, fun) do
    spawn_link fn ->
      send parent, {self, fun.(item)}
    end
  end

  def print(item) do
    receive do
      {^item, result} -> result
    end
  end

end
