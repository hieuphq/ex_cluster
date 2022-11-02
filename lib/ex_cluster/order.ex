defmodule ExCluster.Order do
  use GenServer
  require Logger

  def child_spec(customer),
    do: %{
      id: customer,
      start: {__MODULE__, :start_link, [customer]}
    }

  def start_link(customer) do
    Logger.info("Starting Order for #{customer}")

    case GenServer.start_link(__MODULE__, customer, name: via_tuple(customer)) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  # add contents to the customers order
  def add(customer, new_order_contents) do
    GenServer.cast(via_tuple(customer), {:add, new_order_contents})
  end

  # fetch current contents of the customers order
  def contents(customer) do
    GenServer.call(via_tuple(customer), {:contents})
  end

  defp via_tuple(customer) do
    # Order GenServer needs to use Horde.Registry
    # {:via, Registry, {ExCluster.Registry, customer}}
    {:via, Horde.Registry, {ExCluster.Registry, customer}}
  end

  def init(customer) do
    Process.flag(:trap_exit, true)

    # check for order_contents for the customer
    # order_contents = ExCluster.StateHandoff.pickup(customer)
    {:ok, {customer, []}}
  end

  def handle_cast({:add, new_order_contents}, {customer, order_contents}) do
    {:noreply, {customer, order_contents ++ new_order_contents}}
  end

  def handle_call({:contents}, _from, state = {_, order_contents}) do
    {:reply, order_contents, state}
  end

  # at the end of the module add a terminate callback
  def terminate(_reason, {customer, order_contents}) do
    # gracefully terminating, store our order state
    # ExCluster.StateHandoff.handoff(customer, order_contents)
    :ok
  end
end
