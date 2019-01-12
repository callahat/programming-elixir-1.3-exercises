defmodule StackServerTest do
  use ExUnit.Case
  doctest Stack.Server

  test "Stack operations" do

    # Not sure how to reset the Stack.Stash; just having it in the setup didn't seem to reset it at all
    # so just testing sequentially. Seems like running the test, everything has already been started.
    # Web search didn't give me much guidance either.
    # There are probably elixir ways to test the supervisors, right? Couldn't find much more info on that though.
 
    initial_stack = Application.get_env :stack, :initial_stack

    assert Stack.Server.peek() === initial_stack

    assert Stack.Server.push(999) === :ok
    assert Stack.Server.peek === [ 999 | initial_stack ]

    top_item = Stack.Server.pop
    assert top_item === 999
    top_item = Stack.Server.pop
    assert top_item === 9
    assert [ top_item | Stack.Server.peek ] === initial_stack
  end
end
