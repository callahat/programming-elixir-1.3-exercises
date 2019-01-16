defmodule Fib do
  def of(0), do: 0
  def of(1), do: 1
  def of(n), do: Fib.of(n-1) + Fib.of(n-2)
end

IO.puts "Start the task"
w = Task.async(fn -> Fib.of(37) end)
IO.puts "Do something else"

IO.puts "Fib of 5"
IO.puts inspect Fib.of(5)

IO.puts "Wait for the task"
result = Task.await(w)

IO.puts "The result: #{result}"

IO.puts "The otherway"
w = Task.async(Fib, :of, [37])
result = Task.await(w)
IO.puts "The result: #{result}"

