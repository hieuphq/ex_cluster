defmodule ExCluster.Observe do
  use GenServer

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    {:ok, nil, {:continue, :begin}}
  end

  def handle_continue(:begin, state) do
    Process.send(__MODULE__, :schedule, [])
    {:noreply, state}
  end

  def handle_info(:schedule, state) do
    {:ok, hostname} = :inet.gethostname()
    IO.inspect(hostname)
    IO.inspect(Node.list())

    Process.send_after(__MODULE__, :schedule, 10 * 1000)
    {:noreply, state}
  end
end
