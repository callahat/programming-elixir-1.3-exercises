defmodule Ex3 do
  import :timer, only: [sleep: 1]
  def tattle ppid do
    send(ppid, "ughn")
    send(ppid, "hmmhmph")
    exit(:ok)
#    raise "that went well"
  end

  def run do
#    spawn_link(Ex3, :tattle, [self()])
    spawn_monitor(Ex3, :tattle, [self()])
    sleep(500)
    receive_messages()
  end

  def receive_messages do
    receive do
      msg ->
        IO.puts "Recieved message: #{inspect msg}"
        receive_messages()
    after 1000 ->
        IO.puts "No more messages AFAIK"
    end
  end
end

Ex3.run
