defmodule Ticker do

  @interval 2000     # 2 seconds
  @name     :ticker

  def start do
    if :global.whereis_name(@name) == :undefined do
      pid = spawn(__MODULE__, :generator, [[]])
      :global.register_name(@name, pid)
    else
      IO.puts "Ticker server already running #{ inspect :global.whereis_name(:ticker)}"
    end
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(clients) do
    receive do
      { :register, pid } ->
        IO.puts("registering #{inspect pid}")
        generator([pid|clients])
    after
      @interval ->
        IO.puts "tick"
        send_tock(clients)
    end
  end

  defp send_tock([client | next_clients]) do
    send client, { :tick }
    generator(next_clients++[client])
  end

  defp send_tock([]), do: generator([])
end

defmodule Client do

  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      { :tick } ->
        IO.puts "tock in client"
        receiver
    end
  end
end
