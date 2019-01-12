defmodule Stack.Server do
  use GenServer

  # External API

  @doc """
  Starts the Stack Server using the given stash_pid as the process used to save/get 
  the state of the stack when the server starts/stops
  """
  def start_link(stash_pid) do
    {:ok,_pid} = GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  @doc """
  Remove the top item from the stack and return it
  """
  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  @doc """
  Add an item to the top of the stack, nothing is returned
  """
  def push(value) when value == 9000 do
    raise "#{value} - What nine thousand!?!"
  end

  def push(value) do
    GenServer.cast(__MODULE__, {:push, value})
  end

  @doc """
  Peek at the current state of the stack. Returns an array of the stack (does not mutate the stack)
  """
  def peek() do
    GenServer.call(__MODULE__, :peek)
  end

  # GenServer

  def init(stash_pid) do
    stack = Stack.Stash.get_value stash_pid
    { :ok, {stack, stash_pid} }
  end

  def handle_call(:pop, _from, {[head | tail], stash_pid}) do
    {:reply, head, {tail, stash_pid}}
  end

  def handle_call(:peek, _from, {stack, stash_pid}) do
    {:reply, stack, {stack, stash_pid}}
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
