defmodule LineSigil do
  @doc"""
  Implement the '~l' sigil, which takes a string containing multiple lines
  and returns a list of those lines.

  ## Example

  iex> import LineSigil
  nil
  iex> ~l\"""
  ...> one
  ...> duh
  ...> tree
  ...> \"""
  ["one", "duh", "tree"]
  """
  def sigil_l(lines, _opts) do
    lines |> String.split("\n") |> Enum.map(&String.trim(&1))
  end

  @doc"""
  Similar to ~l, but no interpolation performed
  """
  def sigil_L(lines, _opts) do
    lines |> String.split("\n") |> Enum.map(&String.trim(&1))
  end
end
