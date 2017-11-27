defmodule Collections do
  def all?([head | tail], fun) do
    fun.(head) && all?(tail, fun)
  end
  def all?([], _) do true end


  def each [head | tail], fun do
    fun.(head)
    each(tail, fun)
  end
  def each [], _ do :ok end

  def filter [head | tail], fun do
    if fun.(head), do: [ head | filter(tail, fun)],
                   else: filter(tail,fun)
  end
  def filter [], _ do [] end

  def split_with(list, fun) do
    {filter(list, fun), filter(list, fn a-> !fun.(a) end)}
  end

  def split([head|tail], index) when index > 0 do
    {left, right} = split tail, index - 1
    {[head | left], right}
  end
  def split list, _index do {[], list} end


  def sleep(seconds) do
    receive do
      after seconds * 1000 -> nil
    end
  end

  def say(text) do
    spawn fn -> :os.cmd('espeak #{text}') end
  end

  def timer do
    Stream.resource(
      fn -> 
        {_h, _m, s} = :erlang.time
        60 - s - 1
      end,
      fn 0 -> {:halt,0}
         count -> sleep(1)
           {[inspect(count)], count - 1}
      end,
      fn _ -> nil end
    )
  end

  def span(from, to) when from < to do
    [from | span(from + 1, to)]
  end
  def span from,to do
    [ from ]
  end

  def prime_between_2_and whatever do
    for n <- span(2,whatever), Enum.all?(span(2,n-1), &(rem(n , &1) != 0)), into: [2], do: n 
  end
  
  def shipping tax_rates, orders do
    for order <- orders do
      IO.inspect order
      if tax_rates[order[:ship_to]] do
        Keyword.put(order, :total, order[:net_amount] * (1 + tax_rates[order[:ship_to]]))
      else
        Keyword.put(order, :total, order[:net_amount])
      end
    end
  end
end
