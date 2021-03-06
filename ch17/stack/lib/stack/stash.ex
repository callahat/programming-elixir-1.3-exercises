defmodule Stack.Stash do
  use GenServer

  #####
  # External API

  def start_link(stack) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, stack)
  end

  def save_value(pid, value) do
    GenServer.cast pid, {:save_value, value}
  end

  def get_value(pid) do
    GenServer.call pid, :get_value
  end

  ####
  # GenServer implementation

  def handle_call(:get_value, _from, value) do
    { :reply, value, value }
  end

  def handle_cast({:save_value, value}, _current_value) do
    { :noreply, value }
  end
end
