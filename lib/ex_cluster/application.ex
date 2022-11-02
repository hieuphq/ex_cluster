defmodule ExCluster.Application do
  use Application

  def start(_type, _args) do
    # topologies = [
    #   example: [
    #     strategy: Cluster.Strategy.Epmd,
    #     config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]]
    #   ]
    # ]

    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      {Cluster.Supervisor, [topologies, [name: ExCluster.ClusterSupervisor]]},
      # ..other children..
      {Horde.Registry, [name: ExCluster.Registry, keys: :unique]},
      {Horde.DynamicSupervisor, [name: ExCluster.OrderSupervisor, strategy: :one_for_one]},
      {ExCluster.Observe, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ExCluster.Supervisor)
  end
end
