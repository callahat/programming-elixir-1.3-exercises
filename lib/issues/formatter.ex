defmodule Issues.Formatter do

  @moduledoc """
  Format a list of Github issues into a simple text table
  for the given columns.
  """

  def print_table_for_columns(issues_list, columns) do
    split_into_columns(issues_list,columns)
    |> right_pad
    |> columns_to_rows
    |> print_table
  end

  def split_into_columns(issues_list, columns) do
    for column <- columns do
      [ column | for(issue <- issues_list, do: stringify( issue[column] )) ]
    end
  end

  def stringify(item) when is_integer(item), do: to_string(item)
  def stringify(item), do: item

  def right_pad(column_data) do
    for column <- column_data do
      right_pad_helper(column, Enum.map(column, &String.length/1) |> Enum.max )
    end
  end

  defp right_pad_helper(column, column_width) do
    for row <- column, do: String.pad_trailing(row, column_width)
  end

  def print_table([header | data_rows]) do
    IO.puts(Enum.join(header, " | "))
    IO.puts(header_bar(header))
    print_row_data(data_rows)
  end

  def header_bar(header_row) do
    Enum.map(header_row, fn header -> String.duplicate("-", String.length(header)) end )
    |> Enum.join("-+-")
  end

  def print_row_data([ head | tail ]) do
    IO.puts(Enum.join(head, " | "))
    print_row_data tail
  end
  def print_row_data([]), do: :ok

  def columns_to_rows(columns) do
    row_count = List.first(columns) |> length
    Enum.flat_map(columns, fn x -> x end)
    |> Enum.with_index
    |> Enum.group_by(fn {_, index} -> rem(index, row_count) end )
    |> Enum.map(fn {_,rows_with_index} -> rows_with_index end)
    |> Enum.map(fn rows_with_index -> for {row,_} <- rows_with_index, do: row end)
  end

end
