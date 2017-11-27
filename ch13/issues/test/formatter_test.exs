defmodule FormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Issues.Formatter

  alias Issues.Formatter, as: F

  def simple_test_data() do
    [%{"c1" => "r1 c1", "c2" => "r1 c2",   "c3" => "r1 c3", "c4" => "r1+++c4"},
     %{"c1" => "r2 c1", "c2" => "r2 c2",   "c3" => "r2 c3", "c4" => "r2 c4"},
     %{"c1" => "r3 c1", "c2" => "r3 c2",   "c3" => "r3 c3", "c4" => "r3 c4"},
     %{"c1" => "r4 c1", "c2" => "r4++c2",  "c3" => "r4 c3", "c4" => "r4 c4"}]
  end

  def headers, do: ["c1", "c2", "c4"]

  def split_into_three_columns(), do: F.split_into_columns(simple_test_data(), headers())

  test "split_into_columns" do
    columns = split_into_three_columns()
    assert length(columns)     == length(headers())
    assert List.first(columns) == [ "c1", "r1 c1", "r2 c1", "r3 c1", "r4 c1" ]
    assert List.last(columns)  == [ "c4", "r1+++c4", "r2 c4", "r3 c4", "r4 c4" ]
  end

  test "right_pad" do
    assert F.right_pad(
         [["a",   "aba", "co" ], ["different","column",   "here"     ]]
    ) == [["a  ", "aba", "co "], ["different","column   ","here     "]]
  end
  
  test "header_bar" do
    assert F.header_bar(["a  ", "bbb", "1234"]) == "----+-----+-----"
  end

  test "Output is correct" do
    result = capture_io fn ->
      F.print_table_for_columns(simple_test_data(),headers())
    end

    assert result == """
    c1    | c2     | c4     
    ------+--------+--------
    r1 c1 | r1 c2  | r1+++c4
    r2 c1 | r2 c2  | r2 c4  
    r3 c1 | r3 c2  | r3 c4  
    r4 c1 | r4++c2 | r4 c4  
    """
  end
end
