defmodule WpConfigWriter.MixProject do
  use Mix.Project

  def project do
    [
      app: :wp_config_writer,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: load_paths(Mix.env()),
      config_path: "./config/config.exs",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript(),
      aliases: aliases()
    ]
  end

  defp escript do
    [main_module: Mix.Tasks.WpConfig.Write]
  end

  defp load_paths(:test) do
    ["lib", "test/support"]
  end

  defp load_paths(_) do
    ["lib"]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :eex, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mock, "~> 0.3", only: [:test]},
      {:bypass, "~> 1.0", only: [:test]},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.1"},
      {:myxql, "~> 0.2.0"}
    ]
  end

  def aliases do
    [
      check: &check/1
    ]
  end

  defp check(_) do
    Mix.shell().info("Running the command.")
  end
end
