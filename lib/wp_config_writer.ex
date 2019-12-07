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
end
