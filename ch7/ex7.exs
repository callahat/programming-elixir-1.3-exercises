defmodule MyList do
  def sum([]), do: 0
  def sum([ head | tail ]), do: head + sum(tail)

  def mapsum([], _func), do: 0
  def mapsum([head | tail], func), do: func.(head) + mapsum(tail, func)

  def max([head]), do: head
  def max([a | [b | tail]]) when a > b, do: max([a | tail])
  def max([a | [b | tail]]) when a < b, do: max([b | tail]) 

  def caesar([], _n), do: [] 
  def caesar([head|tail], n) when (head+n) > 122, do: [head + n - 122 + 96 | caesar(tail,n)] 
  def caesar([head|tail], n), do: [head + n | caesar(tail,n)] 
end
