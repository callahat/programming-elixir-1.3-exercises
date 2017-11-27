defmodule Goop do
  def sum(0), do: 0
  def sum(n), do: n + sum(n-1)
  
  def gcd(x,0), do: x
  def gcd(x,y), do: gcd(y,rem(x,y))
end 


defmodule Chop do
  def guess(n, a..b) when n in a..b do
    IO.puts guess(n, midpoint(a..b), a..b)
  end
  def guess(n, x, _range) when n == x do
     IO.puts "Is it #{x}"
     x
  end
  def guess(n, x, _a..b) when x < n do
    IO.puts "Is it #{x}"
    guess(n, midpoint(x..b), x..b)
  end
  def guess(n, x, a.._b) when x > n do
    IO.puts "Is it #{x}"
    guess(n, midpoint(a..x), a..x)
  end

  def midpoint(a..b) do
    div(b-a, 2) + a
  end
end
