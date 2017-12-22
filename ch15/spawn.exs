defmodule Spawn do
  def greet do
    IO.puts "Hello"
  end
end

defmodule Spawn1 do
  def greet do
    receive do
      {sender, msg} ->
        send sender, { :ok, "Hello, #{msg}" }
        greet
    end
  end
end

pid = spawn(Spawn1, :greet, [])
send pid, {self(), "World"}

receive do
  {:ok, message} -> IO.puts message
end


pid = spawn(Spawn1, :greet, [])
send pid, {self(), "Moon"}

receive do
  {:ok, message} -> IO.puts message
end
