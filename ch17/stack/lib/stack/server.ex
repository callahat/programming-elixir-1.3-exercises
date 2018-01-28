defmodule Stack.Server do
  use GenServer

  # External API

  def start_link(stash_pid) do
    {:ok,_pid} = GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  def push(value) when value == 9000 do
    raise "#{value} - What nine thousand!?!"
  end

  def push(value) do
    GenServer.cast(__MODULE__, {:push, value})
  end

  # GenServer

  def init(stash_pid) do
    stack = Stack.Stash.get_value stash_pid
    { :ok, {stack, stash_pid} }
  end

  def handle_call(:pop, _from, {[head | tail], stash_pid}) do
    {:reply, head, {tail, stash_pid}}
  end

  def handle_cast({:push, value}, {stack, stash_pid}) do
    {:noreply, {[value|stack], stash_pid}}
  end

  def terminate(reason, {stack, stash_pid}) do
    IO.puts "Terminating"
    IO.puts inspect(stack)
    IO.puts inspect(reason)
    Stack.Stash.save_value stash_pid, stack
  end
end
