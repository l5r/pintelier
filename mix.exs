defmodule Pintelier.MixProject do
  use Mix.Project

  def project do
    [
      app: :pintelier,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Pintelier.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp asset_dep(name, github, rest \\ []) when is_list(rest) do
    {name,
     Keyword.merge(
       [github: github, app: false, compile: false, depth: 1],
       rest
     )}
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.0"},
      {:phoenix, "~> 1.7.18"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0.0"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      asset_dep(:heroicons, "tailwindlabs/heroicons", tag: "v2.1.1", sparse: "optimized"),
      {:daisyui, path: "./assets/vendor/daisyui", app: false, compile: false},
      {:"postcss-js", path: "./assets/vendor/postcss-js", app: false, compile: false},
      asset_dep(:picocolors, "alexeyraspopov/picocolors", tag: "v1.1.1"),
      asset_dep(:"css-selector-tokenizer", "css-modules/css-selector-tokenizer", tag: "v0.8.0"),
      asset_dep(:fastparse, "webpack/fastparse", tag: "v1.1.2"),
      asset_dep(:cssesc, "mathiasbynens/cssesc", tag: "v3.0.0"),
      {:swoosh, "~> 1.5"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.26"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"},
      {:waffle, "~> 1.1"},
      # Waffle S3 deps
      {:ex_aws, "~> 2.1.2"},
      {:ex_aws_s3, "~> 2.0"},
      {:hackney, "~> 1.9"},
      {:sweet_xml, "~> 0.6"},
      {:waffle_ecto, "~> 0.0"},
      {:timex, "~> 3.7"},
      {:backpex, "~> 0.10.0"}
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
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind pintelier", "esbuild pintelier"],
      "assets.deploy": [
        "tailwind pintelier --minify",
        "esbuild pintelier --minify",
        "phx.digest"
      ]
    ]
  end
end
