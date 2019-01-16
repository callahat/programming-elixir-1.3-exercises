defmodule Frequency do

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add_word(word) do
    Agent.update(__MODULE__, fn map -> 
                               Map.update(map, word, 1, &(&1+1))
                             end)
  end

  def count_for_word(word) do
    Agent.get(__MODULE__, fn map -> map[word] end)
  end

  def words do
    Agent.get(__MODULE__, fn map -> Map.keys(map) end)
  end

  def words_and_counts do
    pretty_print Agent.get(__MODULE__, fn map -> map end)
  end

  defp pretty_print map do
    with sorted_words = Map.keys(map) |> Enum.sort,
         longest_word = longest_word(words, 4),
         format = format_for(longest_word)
    do
      :io.format format, ["Word", "Count"]
      for word <- sorted_words do
        %{ ^word => count } = map
        :io.format format, [word, to_string(count)]
      end
    end  
  end

  defp longest_word([], count), do: count
  defp longest_word([head|tail], count), do: longest_word(tail, max(String.length(head), count))

  defp format_for(padding) do
    "~-#{padding}s ~5s~n"
  end

end
