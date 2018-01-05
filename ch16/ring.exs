defmodule RingClient do

  @interval 2000     # 2 seconds
  @name     :ring

  def join do
    pid = spawn_link(__MODULE__, :loop, [get_root()])

    # Noop if this is not the first to join, and if the first to join has not gone away
    :global.register_name(@name, pid)
    send(get_root(), {:register, pid})
    if(pid == get_root()) do
      send(pid, {:tick, self()})
    end
  end

  def loop(next_pid \\ self()) do
    root = get_root()
    receive do
      { :register, pid } when next_pid == root ->
        IO.puts "#{inspect self()} -> #{inspect pid}"
        loop(pid)
      { :register, pid } ->
        IO.puts "#{inspect self()} -> #{inspect next_pid}"
        send(next_pid, {:register, pid})
      { :tick, pid } ->
        IO.puts "#{inspect self()} got tock from #{inspect pid}"
        :timer.sleep @interval
        send(next_pid, {:tick, self()})
    end
    loop(next_pid)
  end

  def get_root do
    :global.whereis_name(@name)
  end
end
