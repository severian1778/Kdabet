defmodule KdabetUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        fullstack: [
          applications: [
            kdabet_frontend: :permanent,
            mlbschedule: :permanent
          ]
        ]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      # {:castore, "~> 1.0"}
      {:castore, ">= 0.1.0",
       [env: :prod, hex: "castore", repo: "hexpm", optional: false, override: true]}
    ]
  end
end
