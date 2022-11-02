import Config

config :libcluster,
  topologies: [
    default: [
      strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
      config: [
        service: "ex-cluster-svc",
        application_name: "ex-cluster",
        polling_interval: 10_000
      ]
    ]
  ]
