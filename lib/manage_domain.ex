defmodule WpConfigWriter.Manage.Domain do
  @moduledoc """
  House logic that makes http calls to Digital Oceans
  API to add CNAME.
  """

  @type dns_record :: String.t()
  @type ip_address :: String.t()
  @type error_message :: {:ok, String.t()}
  @type response_map :: map()

  @base "https://api.digitalocean.com/v2/domains"
  @current_app_domain_scope "coworkfiji.com"

  @doc "Checks if subdomain already exists on DNS host and sets it."
  @spec modify_dns_record(dns_record, ip_address) :: response_map | error_message
  def modify_dns_record(domain, ip_address) do
    with {:ok, domain} <- check?(domain) do
      execute_dns_changes(domain, ip_address)
    end
  end

  def get_all_records do
    with {:ok, %{body: data}} <- HTTPoison.get(domain_records_endpoint(), auth_headers()) do
      Jason.decode(data)
    end
  end

  def check?(domain) do
    get_all_records()
    |> domain_already_set(domain)
  end

  defp domain_already_set({:ok, data}, domain),
    do: domain_already_set(data, domain)

  defp domain_already_set(%{"domain_records" => domains}, domain) do
    result = domain not in Enum.map(domains, & &1["name"])

    cond do
      result -> {:ok, domain}
      true -> {:error, "#{domain} already set on DNS host."}
    end
  end

  defp domain_already_set(error, _), do: error

  defp execute_dns_changes(domain, ip_address) do
    params = params(domain, ip_address)

    json_data = Jason.encode!(params)

    with {:ok, %{body: data, status_code: 201}} <-
           HTTPoison.post(domain_records_endpoint(), json_data) do
      Jason.decode(data)
    end
  end

  defp params(domain, ip_address) do
    %{
      type: "A",
      name: domain,
      data: ip_address,
      priority: nil,
      port: nil,
      ttl: 1800,
      weight: nil,
      flags: nil,
      tag: nil
    }
  end

  defp domain_records_endpoint do
    @base <> "/" <> @current_app_domain_scope <> "/records"
  end

  defp auth_headers do
    [Authorization: "Bearer #{token()}"]
  end

  defp token do
    WpConfigWriter.api_token()
  end
end
