import Config

config :libcluster,
  topologies: [
    default: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "ex-cluster",
        kubernetes_selector: "app=ex-cluster,tier=web",
        kubernetes_namespace: "default",
        polling_interval: 10_000
      ]
    ]
  ]
