defmodule Chaperon.Mixfile do
  use Mix.Project

  def project do
    [
      app: :chaperon,
      version: "0.3.1",
      elixir: "~> 1.14",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "An Elixir based HTTP load & performance testing framework",
      dialyzer: [
        plt_add_deps: :apps_direct,
        plt_add_apps: [
          :httpoison,
          :uuid,
          :doma_histogrex
        ],
        flags: [
          # "-Woverspecs",
          # "-Wunderspecs"
        ],
        # skip unkown function warnings
        remove_defaults: [:unknown]
      ],
      # docs
      source_url: "https://github.com/polleverywhere/chaperon",
      docs: [
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      extra_applications: [
        :logger,
        :inets
      ],
      mod: {Chaperon, []}
    ]
  end

  defp package do
    [
      name: "doma_chaperon",
      files: [
        "lib",
        "docs",
        "examples",
        "mix.exs",
        "README*",
        "LICENSE"
      ],
      maintainers: [
        "Christopher Bertels"
      ],
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/doma-engineering/chaperon",
        "Upstream" => "https://github.com/polleverywhere/chaperon"
      }
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:uuid, "~> 1.1"},
      {:doma_histogrex, "~> 0.0.5"},
      {:websockex, "~> 0.4.3"},
      {:e_q, "~> 1.0.0"},
      {:instream, "~> 2.2"},
      {:deep_merge, "~> 1.0"},
      {:cowboy, "~> 2.9"},
      {:plug, "~> 1.14"},
      {:plug_cowboy, "~> 2.6"},
      {:basic_auth, "~> 2.2"},
      {:ex_aws, "~> 2.4"},
      {:ex_aws_s3, "~> 2.3"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.29.1", only: :dev},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end
end
