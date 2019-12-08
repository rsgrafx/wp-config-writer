defmodule WpConfigWriter.Build.Nginx do
  @moduledoc """
  Use regular expressions to parse sample and inject params to
  config file.
  """
  alias WpConfigWriter.Manage.Domain

  def load_sample() do
    Path.expand("../support", __DIR__) <> "/sample.conf.eex"
  end

  def setup(domain_name, abs_name) do
    target_ip = WpConfigWriter.ip_address()

    with {:ok, _} <- Domain.modify_dns_record(domain_name, target_ip) do
      parse_and_write(domain_name, abs_name)
    end
  end

  def parse_and_write(domain_name, base_path) do
    path = strip_path(base_path)
    file = Path.expand("../support", __DIR__) <> "/sample.conf.eex"
    data = EEx.eval_file(file, server: domain_name, root_path: path)
    File.write(path <> "/#{domain_name}.conf", data)
  end

  defp strip_path(path) do
    if path =~ ~r/\/$/ do
      val = String.length(path) - 1
      <<new_path::binary-size(val), _>> = path
      new_path
    else
      path
    end
  end
end
