defmodule Ex3 do
  import Enum, only: [reduce: 3]
  def each(list, fun) do
    reduce(list, :ok, fn(x, _) -> fun.(x) end)
    :ok
  end

  # could use reverse instead of the last reduce, but the exercise did state
  # to solve in terms of reduce...
  def filter(list, fun) do
    list
    |> reduce([], fn(x, acc) -> if fun.(x), do: [x | acc], else: acc end)
    |> _reverse_reducer
  end
  def map(list, fun) do
    list
    |> reduce([], fn(x, acc) -> [ fun.(x) | acc ] end)
    |> _reverse_reducer
  end

  defp _reverse_reducer(list) do
    reduce(list, [], fn(x, acc) -> [x | acc] end)
  end
end
