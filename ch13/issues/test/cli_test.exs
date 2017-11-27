defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [ parse_args: 1, sort_into_ascending_order: 1 ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",     "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == { "user", "project", 99 }
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user_goop", "project"]) == { "user_goop", "project", 4 }
  end

  test "sort ascending orders issues the correct way" do
    result = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    sorted_issues = for issue <- result, do: Map.get(issue, "created_at")
    assert sorted_issues, ~w(a b c)
  end

  defp fake_created_at_list(values) do
    for value <- values, do: %{ "created_at" => value, "other_data" => "junk" }
    # below seems equivalent to the above comprehension. Comprehensions are good shortcuts.
    # Enum.map(values, fn value -> %{ "created_at" => value, "other_data" => "junk" } end )
  end
end
