defmodule Strings do
  def only_printable str do
    str -- Enum.to_list(?\s..?~) == []
  end

  def anagram? a,b do
    (a -- b == []) and (b -- a == [])
  end

  def char_list_math list do
    Enum.filter( list, &(&1 != ?\s) ) 
      |> Enum.chunk_by(&(&1>=?0 and &1<=?9))
      |> extract_number
      |> do_math
  end

  defp extract_number( [ a | [ operation | [ b ] ] ] ) do
    {List.to_integer(a), operation, List.to_integer(b)}
  end

  defp do_math( {a, '+', b} ), do: a + b
  defp do_math( {a, '-', b} ), do: a - b
  defp do_math( {a, '*', b} ), do: a * b
  defp do_math( {a, '/', b} ), do: a / b

  def exercise5 word_list do
    justify_dqs_list({longest_dqs(word_list, 0), word_list}) |>
      Enum.join("\n") |>
      IO.puts
  end

  defp longest_dqs [head | tail], current_max do
    max(longest_dqs(tail, current_max),String.length(head))
  end
  defp longest_dqs [], current_max do
    current_max
  end
  
  defp justify_dqs_list { _justify_width, [] } do
    []
  end
  defp justify_dqs_list { justify_width, [head | tail] } do
    [ justify(head, justify_width) | justify_dqs_list({justify_width, tail}) ]
  end

  def justify dqs, justify_width do
    String.pad_trailing( String.pad_leading(dqs, div(justify_width + String.length(dqs),2)), justify_width)
  end

  def capitalize_sentances string do
    String.split(string, ". ") |>
      Enum.map(&String.capitalize/1) |>
      Enum.join(". ")
  end

  def process_sales_tax filename do
    file = File.open! filename
    keys = _split_line(IO.read(file, :line)) |> Enum.map(&String.to_atom(&1))
    Enum.map(IO.stream(file, :line), &_mapper(&1, keys))
  end
  defp _mapper line,keys do
    line
    |> _split_line   
    |> _format_values
    |> _zip_line(keys)
  end
  defp _split_line line do
    line
    |> String.strip
    |> String.split(",")
  end
  defp _zip_line values, keys do
    Enum.zip keys, values
  end
  defp _format_values values  do
    Enum.map values, fn value -> 
      cond do
        String.starts_with?(value, ":")      -> String.slice(value, 1,2) |> String.to_atom
        String.match?(value, ~r{^\d+\.\d+$}) -> String.to_float(value)
        String.match?(value, ~r{^\d+$})      -> String.to_integer(value)
        true                                 -> value
      end
    end
  end
end 
