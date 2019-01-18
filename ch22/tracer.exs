defmodule Tracer do
  def dump_args(args) do
    args 
    |> Enum.map(&inspect(&1))
    |> Enum.map(&IO.ANSI.format([:yellow, &1, :white],true))
    |> Enum.join(",")
  end

  def dump_defn(name, args) do
    IO.ANSI.format [:blue, "#{name}", :white, "(", "#{dump_args(args)}", ")"], true
  end

  def definer(definition={name,_,args}, content) do
    quote do
      Kernel.def(unquote(definition)) do
        IO.puts IO.ANSI.format [:cyan, "==> call:    #{Tracer.dump_defn(unquote(name), unquote(args))}"], true
        result = unquote(content)
        IO.puts IO.ANSI.format [:cyan, "<== result:  #{IO.ANSI.format [:green, "#{result}"], true}"], true
        result
      end
    end
  end

  defmacro def({:when, _, [definition, _]}, do: content) do
    Tracer.definer(definition, content)
  end

  defmacro def(definition={name, _, args}, do: content) do
    Tracer.definer(definition, content)
  end

  defmacro __using__(_opts) do
    quote do
      import Kernel,              except: [def: 2]
      import unquote(__MODULE__), only:   [def: 2]
    end
  end
end

defmodule Test do
  use Tracer

  def puts_sum_three(a,b,c), do: IO.inspect(a+b+c)
  def add_list(list),        do: Enum.reduce(list, 0, &(&1+&2))
  def puts_sum_one(a) when is_float(a), do: IO.inspect(round(a))
  def puts_sum_one(a), do: IO.inspect(a)
end

Test.puts_sum_three(1,2,3)
Test.add_list([4,5,6,7,8])
Test.puts_sum_one(0)
Test.puts_sum_one(0.7)
