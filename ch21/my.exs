defmodule My do
  def myif(condition, clauses) do
    do_clause   = Keyword.get(clauses, :do, nil)
    else_clause = Keyword.get(clauses, :else, nil)

    case condition do
      val when val in [false, nil]
          -> else_clause
      _otherwise
          -> do_clause
    end
  end

  defmacro macro(param) do
    IO.inspect param
  end
end

IO.puts "My.myif 1==2 ..."
My.myif 1==2, do: IO.puts("1 == 2"), else: IO.puts("1 != 2")

IO.puts ""
IO.puts "defmodule Test..."

defmodule Test do
  require My

  My.macro "Values representing themselves"
  My.macro :atom
  My.macro 1
  My.macro 1.0
  My.macro [1,2,3]
  My.macro "binaries"
  My.macro { 1, 2 }
  My.macro do: 1

  My.macro "And these are represented by 3-element tuples"
  My.macro { 1,2,3,4,5 }

  My.macro do: ( a = 1; a+a )

  My.macro do
    1+2
  else
    3+4
  end

end

