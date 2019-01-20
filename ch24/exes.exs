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
  def sigil_v(lines, opts) do
    _parse_csv(lines, opts)
  end

  @doc"""
  Similar to ~v, but no interpolation performed
  """
  def sigil_V(lines, opts) do
    _parse_csv(lines, opts)
  end

  defp _parse_csv(lines, _opts) do
    lines 
    |> String.split("\n") 
    |> Enum.map(&String.split(&1,","))
    |> Enum.map(&_strip_lists(&1))
  end

  defp _strip_lists(list) do
    list |> Enum.map(&String.trim(&1)) 
  end
end
