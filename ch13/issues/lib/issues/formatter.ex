defmodule Issues.Formatter do

  import Enum, only: [ map: 2, join: 2, max: 1 ]

  @moduledoc """
  Format a list of Github issues into a simple text table
  for the given columns.
  """

  @doc """
  Takes a List of Maps which represent row data, and a list of 
  columns. Prints to STDOUT a formatted table of the row data
  with column headers. Each column is as wide as its widest
  row element.
  """
  def print_table_for_columns(issues_list, columns) do
    split_into_columns(issues_list,columns)
    |> right_pad
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> generate_table
    |> join("\n")
    |> IO.puts
  end

  @doc """
  Given a list of maps (the row data) and list of column headers,
  Returns a list of lists, where each list is a column header and
  the associated row data for that column.

  ## Example

      iex> list = [%{"a" => 1, "b" => 2, "c" => "off"},
      ...>         %{"a" => 4, "b" => "5", "c" => "on"}]
      iex> Issues.Formatter.split_into_columns(list, ["a","b","c"])
      [ ["a", "1", "4"], ["b", "2", "5"], ["c", "off", "on"] ]
  """
  def split_into_columns(issues_list, columns) do
    for column <- columns do
      [ column | for(issue <- issues_list, do: stringify( issue[column] )) ]
    end
  end

  @doc """
  Return a binary (string) of the parameter.

  ## Examples

      iex> Issues.Formatter.stringify("zed")
      "zed"
      iex> Issues.Formatter.stringify(9001)
      "9001"
      iex> Issues.Formatter.stringify('probably breaks')
      "probably breaks"
  """
  def stringify(item) when is_integer(item), do: to_string(item)
  def stringify(item) when is_list(item), do: to_string(item)
  def stringify(item), do: item


  @doc """
  Takes a list of lists. Returns a list of lists, where each inner list
  is right padded to the width of its longest string member.

  ## Example

      iex> Issues.Formatter.right_pad([ ["a", "12", "51232", "999"], ["yes", "no"] ])
      [ ["a    ", "12   ", "51232", "999  "], ["yes", "no "] ]
  """
  def right_pad(column_data) do
    for column <- column_data do
      right_pad_helper(column, map(column, &String.length/1) |> max )
    end
  end

  defp right_pad_helper(column, column_width) do
    for row <- column, do: String.pad_trailing(row, column_width)
  end

  @doc """
  Takes a list of a list of column headers and data rows, and generates 
  a list of rows as string, including the header, header bar, and row
  data. Any padding to normalize the column widths should have already
  been done by the point.

  ## Example

      iex> header_and_data = [ ["One ", "Two  ", "Three"],
      ...>                     ["12  ", "Apple", "Test "],
      ...>                     ["9999", "Pear ", "Data "] ]
      iex> Issues.Formatter.generate_table(header_and_data)
      [
        "One  | Two   | Three",
        "-----+-------+------",
        "12   | Apple | Test ",
        "9999 | Pear  | Data "
      ]
  """
  def generate_table([header | data_rows]) do
    [ join(header, " | ") ] ++
    [ header_bar(header) ] ++
    generate_row_data(data_rows)
  end

  @doc """
  Returns the column header separator bar as a string. The bar is a string of
  hyphens with pluses where the column separators would go.

  ## Example

      iex> Issues.Formatter.header_bar(["One  ", "Two", "Four   "])
      "------+-----+--------"
  """
  def header_bar(header_row) do
    for(header <- header_row, do: String.duplicate("-", String.length(header)))
    |> join("-+-")
  end

  defp generate_row_data([ head | tail ]) do
    [ join(head, " | ") | generate_row_data(tail) ]
  end
  defp generate_row_data([]), do: []
end
