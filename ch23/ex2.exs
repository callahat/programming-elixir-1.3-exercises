defmodule Test do
  def test(word_list \\ "scowl_words_lowercase.txt") do
    words = word_list
            |> File.stream!
            |> Stream.map(&String.strip(&1))
            |> Stream.map(&String.downcase(&1))
            |> Enum.reduce(MapSet.new, fn(word, acc) -> MapSet.put(acc, word) end)

    words
    |> Enum.filter(&rot13_present_in_list?(words, &1))
  end

  defp rot13_present_in_list?(words, word) do
    MapSet.member?(words, Caeser.rot13(String.downcase(word)))
  end
end

short_list = Test.test
mid_list =  Test.test "scowl_words_mid_list.txt"
long_list =  Test.test "scowl_words_long_list.txt"

IO.puts "----------------"
IO.puts "Short list rot13 count: #{length short_list}"
IO.puts "List:"
IO.puts inspect short_list

IO.puts "----------------"
IO.puts "Mid list rot13 count: #{length mid_list}"
IO.puts "List:"
IO.puts inspect mid_list

IO.puts "----------------"
IO.puts "Long list rot13 count: #{length long_list}"
IO.puts "List:"
IO.puts inspect long_list
