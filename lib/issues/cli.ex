defmodule Issues.CLI do

  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  def process(:help) do
    IO.puts """
    useage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> sort_into_ascending_order
    |> Enum.take(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, error}) do
    {_, message} = Map.fetch(error, "message")
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  def sort_into_ascending_order(issues_list) do
    Enum.sort issues_list, fn a, b -> Map.get(a, "created_at") <= Map.get(b, "created_at") end
  end

  def print_table_for_columns(issues_list, columns) do
    split_into_columns(issues_list,columns)
    |> right_pad
    |> columns_to_rows
    |> print_table
  end

  def split_into_columns(issues_list, columns \\ ["id", "created_at", "title"]) do
    for column <- columns do
      [ column | for(issue <- issues_list, do: stringify(Map.get(issue, column))) ]
    end
  end

  def stringify(item) when is_integer(item) do
    Integer.to_string(item)
  end
  def stringify(item), do: item

  def right_pad(column_data) do
    for column <- column_data do
      right_pad_helper(column, longest_line_size(column, 0))
    end
  end

  defp longest_line_size([], longest), do: longest
  defp longest_line_size([head | tail], longest) do
    case String.length(head) do
      x when x > longest -> longest_line_size(tail, x)
      _ -> longest_line_size(tail, longest)
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

  @doc """
  `argv` can be -h or --help, which returns :help

  Otherwise it is a github username, project name, and (optionally)
  the number of entries to format.

  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                    aliases:  [ h:    :help])
    case parse do
    { [ help: true ], _, _ } 
      -> :help

    { _, [ user, project, count], _ }
      -> { user, project, String.to_integer(count) }

    { _, [user, project], _ }
      -> { user, project, @default_count}

    _ -> :help
    end
  end
end
