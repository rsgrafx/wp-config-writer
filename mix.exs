defmodule WpConfigWriter.MixProject do
  use Mix.Project

  def project do
    [
      app: :wp_config_writer,
      version: "0.1.0",
      elixir: "~> 1.9",
      config_path: "./config/config.exs",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  defp escript do
    [main_module: Mix.Tasks.WpConfig.Write]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :eex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:myxql, "~> 0.2.0"}
    ]
  end
end
