defmodule WpConfigWriter do
  @moduledoc """
  Documentation for WpConfigWriter.
  """

  def build_file(path, data) do
    File.write(path <> "/wp-config.php", data)
  end

  def write_define(param, key) do
    WpConfigWriter.Build.define(param, key)
  end

  def api_token do
    Application.get_env(:wp_config_writer, :dns_provider)[:key]
  end

  def ip_address do
    Application.get_env(:wp_config_writer, :dns_provider)[:ip_address]
  end

  def database_configs do
    configs = Application.get_env(:wp_config_writer, :myxql)

    Enum.map(configs, fn {k, v} ->
      {k, mask(v)}
    end)
  end

  defdelegate mask(string), to: WpConfigWriter.Utils
end
