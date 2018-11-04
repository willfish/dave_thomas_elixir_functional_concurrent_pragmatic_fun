defmodule Atmos.MixProject do
  use Mix.Project

  def project do
    [
      app: :atmos,
      name: "Atmos",
      version: "0.1.0",
      elixir: "~> 1.7",
      escript: escript_config(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.4.0"},
      {:poison, "~> 4.0.1"},
      {:scribe, "~> 0.8"}
    ]
  end

  def escript_config do
    [main_module: Atmos.CLI]
  end
end
