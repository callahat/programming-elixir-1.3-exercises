defmodule Stats do
  @moduledoc """
  Just a simple stats module taken from Ch14
  """

  def sum(vals),     do: vals |> Enum.reduce(0, &+/2)
  def count(vals),   do: vals |> length
  def average(vals), do: sum(vals) / count(vals)
end

