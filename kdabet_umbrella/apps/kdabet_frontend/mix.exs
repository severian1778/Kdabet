defmodule KdabetFrontend.MixProject do
  use Mix.Project

  def project do
    [
      app: :kdabet_frontend,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      compilers: Mix.compilers() ++ [:surface]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {KdabetFrontend.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"] ++ catalogues()
  defp elixirc_paths(:dev), do: ["lib"] ++ catalogues()
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.7"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.19.0"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.0"},
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:plug_cowboy, "~> 2.5"},
      ## additions
      {:dart_sass, "~> 0.6", runtime: Mix.env() == :dev},
      {:ex_fontawesome, "~> 0.7.2"},
      {:surface, "~> 0.11.0"},
      {:surface_catalogue, "~> 0.6.0"},
      ## currently this is a stop gap fix for Sourceror. https://github.com/surface-ui/surface/issues/707
      {:sourceror, "~> 0.12.0"},
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:jason, "~> 1.3"},
      {:kadena, "~> 0.19.0"},
      {:vega_lite, "~> 0.1.8"},
      {:nx, "~> 0.5"},
      {:kino_vega_lite, "~> 0.1.8"},
      ## import umbrella apps
      ##{:crashgame,  in_umbrella: true},
      {:schedules, in_umbrella: true}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["esbuild default", "sass default", "tailwind default"],
      "assets.deploy": [
        "sass default",
        "esbuild default --minify",
        "tailwind default --minify",
        "phx.digest"
      ]
    ]
  end

  def catalogues do
    [
      "priv/catalogue"
    ]
  end
end
