inspect self()
defimpl Inspect, for: PID do
  def inspect(pid, _) do
    "#The Process: " <> IO.iodata_to_binary(:erlang.pid_to_list(pid)) <> "!!!111one"
  end
end
inspect self()
