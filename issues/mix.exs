defmodule Issues.MixProject do
  use Mix.Project

  def project do
    [
      app: :issues,
      version: "0.1.0",
      name: "Issues",
      source_url: "https://github.com/willfish/issues",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      escript: escript_config(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:earmark, "~> 1.2.6"},
      {:ex_doc, "~> 0.19.1"},
      {:httpoison, "~> 1.4.0"},
      {:poison, "~> 4.0.1"}
    ]
  end

  defp escript_config do
    [main_module: Issues.CLI]
  end
end
