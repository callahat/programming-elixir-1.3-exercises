defmodule Weather.CLI do

  @moduledoc """
  Handle the command line parsing and dispatch
  of the various functions used to pull a weather
  report from an airport provided by weather.gov
  """  
  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which will return :help

  Otherwise it can be a 4 character airport symbol.
  If not supplied, KMGY will be returned.

  Returns a string of `<airport symbol>`, or :help if help was given
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help])

    case parse do
    { [help: true], _, _ } -> :help
    { _, [airport], _ } -> String.upcase(airport)
    _ -> "KMGY"
    end
  end

  @doc """
  Process the given command.
  """
  def process(:help) do
    IO.puts """
      useage: weather [airport symbol]
    """
    System.halt(0)
  end
  def process(airport) do
    Weather.WeatherService.fetch(airport)
    |> format
  end

  @doc """
  Print a map of weather readings nicely formatted in two columns.
  """
  def format(stats) do
    with padding = stats |> Map.keys |> Enum.map(&length/1) |> Enum.max,
         format  = format_for(padding),
         stat_list = stats |> Map.to_list |> Enum.map(&Tuple.to_list/1)
    do   Enum.each(stat_list, fn stat -> put_one_line(stat, format) end)
    end
  end

  @doc """
  Returns the formatting string with the first column being
  `padding` characters wide
  """
  def format_for(padding) do
    "~-#{padding}s ~s~n"
  end

  @doc """
  `stat` is a list of a measure and quantitiy
  `format` is the formatting string

  ie.
  ```
  > put_one_line(['measure','value'], "~-10s ~s~n")
  # measure    value
  ```
  """
  def put_one_line(stat, format) do
    :io.format format, stat
  end

end
