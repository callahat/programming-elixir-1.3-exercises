defmodule CliTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Weather.CLI

  import Weather.CLI, only: [ parse_args: 1, format_for: 1, format: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["KMGY"]) == "KMGY"
  end

  test "format_for" do
    assert format_for(20) == "~-20s ~s~n"
  end

  test "format" do
    result = capture_io fn ->
      format sample_stats()
    end

    assert result == """
    degrees_farenheit 9000
    station_id        KMGY
    """
  end

  defp sample_stats() do
    %{'station_id' => 'KMGY', 'degrees_farenheit' => '9000' }
  end
end
