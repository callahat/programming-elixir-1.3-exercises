defmodule My do
  defmacro mydef(name) do
    quote bind_quoted: [derp: name] do
      def unquote(derp)(), do: unquote(derp)
    end
  end
end

defmodule Test do
  require My
  [:fred, :bort] |> Enum.each(&My.mydef(&1))
end

IO.puts Test.fred
IO.puts Test.bort
