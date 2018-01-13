defmodule Ex16 do
  def listing do
    IO.puts(Enum.join(File.ls!, ","))
  end
end
