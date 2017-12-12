defmodule StatsTest do
  use ExUnit.Case
  use ExCheck

  setup_all do
    on_exit( fn -> IO.puts("Thats a wrap") end )
  end

  describe "Stats on lists of ints" do

    setup do
      on_exit( fn -> IO.puts("Done") end )
      [ list:  [1, 3, 5, 7, 9, 11],
        sum:   36,
        count: 6
      ]
    end

    test "calculates sum", fixture do
      assert Stats.sum(fixture.list) == fixture.sum
    end

    test "calculates count", fixture do
      assert Stats.count(fixture.list) == fixture.count
    end

    test "calculates average", fixture do
      assert Stats.average(fixture.list) == fixture.sum / fixture.count
    end
  end
end
