defmodule Times do
  defmacro times_n(number) do
    quote do
      def unquote(:"times_#{number}")(n) do
        unquote(number) * n
      end
    end
  end

  defmacro plus_n(number) do
    quote do: (def unquote(:"plus_#{number}")(n), do: unquote(number) + n)
  end
end

defmodule Test do
  require Times
  Times.times_n(3)
  Times.times_n(4)

  Times.plus_n(10)
  Times.plus_n(100)
end

IO.puts Test.times_3(3)
IO.puts Test.times_4(3)

IO.puts Test.plus_10(-10)
IO.puts Test.plus_100(-50)
