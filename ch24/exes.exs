defmodule CsvSigil do
  @doc"""
  Implement the '~v' sigil, which takes a string containing multiple lines
  with delimiting commas, and returns a list of lists of the comma separated
  values.

  ## Example

  iex> import CsvSigil
  nil
  iex> ~v\"""
  ...> 1,2,3
  ...> cat,mog
  ...> \"""
  [["1,", "2", "3"],["cat","mog"]]
  """
  def sigil_v(lines, []),  do: _parse_csv(lines)
  def sigil_v(lines, 'h'), do: _parse_csv(lines) |> _merge_headers

  @doc"""
  Similar to ~v, but no interpolation performed
  """
  def sigil_V(lines, []),  do: _parse_csv(lines)
  def sigil_V(lines, 'h'), do: _parse_csv(lines) |> _merge_headers

  defp _parse_csv(lines) do
    lines
    |> String.split("\n")
    |> Enum.map(&String.split(&1,","))
    |> Enum.map(&_strip_lists(&1))
    |> Enum.map(&_parse_numbers_in_list(&1))
  end

  defp _strip_lists(list) do
    list |> Enum.map(&String.trim(&1)) 
  end

  defp _parse_numbers_in_list(list) do
    list |> Enum.map(&_parse_number(&1))
  end

  defp _parse_number(item) do
    case Float.parse(item) do
      :error      -> item
      {float, ""} -> _as_int_if_int(float)
      _           -> item
    end
  end

  defp _as_int_if_int(number) do
    if Float.floor(number) == number,
    do:   trunc(number),
    else: number
  end

  defp _merge_headers([headers | data]) do
    with atomized_headers = headers |> Enum.map(&String.to_atom(&1)),
    do:  data |> Enum.map(&Enum.zip(atomized_headers, &1))
  end
end
