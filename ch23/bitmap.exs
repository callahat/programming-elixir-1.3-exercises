defmodule Bitmap do
  defstruct value: 0

  @doc """
  A simple accessor for the 2^bit value in an integer

    iex> b = %Bitmap{value: 5}
    %Bitmap{value: 5}
    iex> Bitmap.fetch_bit(b, 2)
    1
    iex> Bitmap.fetch_bit(b, 1)
    0
    iex> Bitmap.fetch_bit(b, 0)
    1
  """
  def fetch_bit(%Bitmap{value: value}, bit) do
    use Bitwise

    (value >>> bit) &&& 1
  end
end

defimpl Enumerable, for: Bitmap do
  import :math, only: [log: 1]

  def count(%Bitmap{value: value}) when value == 0 do
    {:ok, 1}
  end
  def count(%Bitmap{value: value}) do
    {:ok, trunc(log(value)/log(2)) + 1}
  end

  def member?(value, bit_number) do
    {:ok, 0 <= bit_number && bit_number < Enum.count(value)}
  end

  def reduce(bitmap, {:cont, acc}, fun) do
    bit_count = Enum.count(bitmap)
    _reduce({bitmap, bit_count-1}, {:cont, acc}, fun)
  end

  defp _reduce({_bitmap, -1}, {:cont, acc}, _fun), do: {:done, acc}

  defp _reduce({bitmap, bit_number}, {:cont, acc}, fun) do
    with bit = Bitmap.fetch_bit(bitmap, bit_number),
    do:  _reduce({bitmap, bit_number-1}, fun.(bit, acc), fun)
  end

  defp _reduce({_bitmap, _bit_number}, {:halt, acc}, _fun), do: {:halted, acc}

  defp _reduce({bitmap, bit_number}, {:suspend, acc}, fun),
    do: { :suspended, acc, &_reduce({bitmap, bit_number}, &1, fun), fun }

  defimpl Inspect, for: Bitmap do
    import Inspect.Algebra
    def inspect(%Bitmap{value: value}, _opts) do
      concat([
        nest(
          concat([
            "%Bitmap{",
            break(""),
            nest(concat([to_string(value),
                         "=",
                         break(""),
                         as_binary(value)]),
                 2),
          ]), 2),
        break(""),
      "}"])
    end
    defp as_binary(value) do
      to_string(:io_lib.format("~.2B", [value]))
    end
  end
end

defimpl Collectable, for: Bitmap do
  use Bitwise

  def into(%Bitmap{value: target}) do
    {target, fn
      acc, {:cont, next_bit} -> (acc <<< 1) ||| next_bit
      acc, :done             -> %Bitmap{value: acc}
      _,   :halt             -> :ok
    end}
  end
end

defimpl String.Chars, for: Bitmap do
  def to_string(bitmap) do
    import Enum
    bitmap
    |> reverse
    |> chunk(4,4,[0,0,0,0])
    |> map(fn n_bits -> n_bits |> reverse |> join end)
    |> reverse
    |> join("_")
  end
end

#IO.puts "%Bitmap{value: 5}"
#b5 = %Bitmap{value: 5}
#IO.puts "Bit count: #{Enum.count(b5)}"
#IO.puts "Bits:"
#IO.puts inspect Bitmap.fetch_bit(b5, 2)
#IO.puts inspect Bitmap.fetch_bit(b5, 1)
#IO.puts inspect Bitmap.fetch_bit(b5, 0)


#IO.puts "%Bitmap{value: 50}"
#b50 = %Bitmap{value: 50}
#IO.puts "Bit count: #{Enum.count(b50)}"
#IO.puts Enum.member? b50, 4
