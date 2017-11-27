defmodule ControlFlow do
  def upto(n) when n > 0 do
    1..n |> Enum.map(&_fizzbuzz/1)
  end
  defp _fizzbuzz n do
    case { rem(n,3), rem(n,5) } do
      { 0, 0 } -> "FizzBuzz"
      { 0, _ } -> "Fizz"
      { _, 0 } -> "Buzz"
      { _, _ } -> n
    end
  end

  def ok! {:ok, data} do
    data
  end
  def ok! param do
    raise "That was unexpected: #{inspect param}"
  end
end
