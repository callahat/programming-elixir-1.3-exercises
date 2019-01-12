defmodule Sequence.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _initial_number) do
    {:ok, _pid} = Sequence.Supervisor.start_link(Application.get_env :sequence, :initial_number)
  end
end
