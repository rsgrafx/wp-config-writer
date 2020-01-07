defmodule WpConfigWriter.Manage.Domain do
  @moduledoc """
  House logic that makes http calls to Digital Oceans
  API to add CNAME.
  """
  defmodule Error do
    defexception [:message]
  end

  import WpConfigWriter.Utils.Guards

  @type dns_record :: String.t()
  @type ip_address :: String.t()
  @type error_message :: {:error, String.t()}
  @type response_map :: {:ok, map()}

  @doc "Checks if subdomain already exists on DNS host and sets it."
  @spec modify_dns_record(dns_record, ip_address) :: response_map | error_message

  def modify_dns_record(domain, ip_address)
      when is_valid(domain) and is_valid(ip_address) do
    with {:ok, domain} <- check?(domain) do
      execute_dns_changes(domain, ip_address)
    end
  end

  def modify_dns_record(_, _) do
    require Logger
    Logger.error("#{__MODULE__} modify_dns_record/2 please verify inputs")

    raise Error,
      message: "#{__MODULE__} modify_dns_record/2 please verify inputs"
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
    result = HTTPoison.post(domain_records_endpoint(), json_data)

    case result do
      {:ok, %{body: data, status_code: status_code}} when status_code in 200..300 ->
        Jason.decode(data)

      {:ok, _http_response} ->
        {:error, "Unable to fulfill request."}

      _ ->
        {:error, "Unable to fulfill request. "}
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
    domain = WpConfigWriter.current_base_domain()
    api_endpoint = WpConfigWriter.current_base_domain()
    api_endpoint <> "/" <> domain <> "/records"
  end

  defp auth_headers do
    [Authorization: "Bearer #{token()}"]
  end

  defp token do
    WpConfigWriter.api_token()
  end
end
