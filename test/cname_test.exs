defmodule WpConfigWriter.Manage.DomainTest do
  use ExUnit.Case
  import Mock

  alias WpConfigWriter.Manage.Domain
  alias WpConfigWriter.Payload.Factory

  # @request """
  # {
  #   "type": "A",
  #   "name": "my-new-subdomain",
  #   "data": "128.199.156.69",
  #   "priority": null,
  #   "port": null,
  #   "ttl": 1800,
  #   "weight": null,
  #   "flags": null,
  #   "tag": null
  # }
  # """

  @response """
  {
    "domain_record": {
      "id": 28448433,
      "type": "A",
      "name": "www",
      "data": "162.10.66.0",
      "priority": null,
      "port": null,
      "ttl": 1800,
      "weight": null,
      "flags": null,
      "tag": null
    }
  }
  """

  def fetch_records do
    fn "https://api.digitalocean.com/v2/domains/coworkfiji.com/records", _ ->
      {:ok,
       %HTTPoison.Response{body: Jason.encode!(Factory.all_records_response()), status_code: 201}}
    end
  end

  def post_records do
    fn "https://api.digitalocean.com/v2/domains/coworkfiji.com/records", _ ->
      {:ok, %HTTPoison.Response{body: @response, status_code: 201}}
    end
  end

  describe "POST ing new cname" do
    test "check?(domain) not on host" do
      with_mock HTTPoison,
        get: fetch_records() do
        assert {:ok, "non-existent-domain"} == Domain.check?("non-existent-domain")

        assert {:error, "instra-au already set on DNS host."} == Domain.check?("instra-au")
      end
    end

    test "200 modify_dns_record/1" do
      with_mock HTTPoison,
        get: fetch_records(),
        post: post_records() do
        assert Jason.decode(@response) ==
                 Domain.modify_dns_record("my-new-subdomain", "128.199.156.69")

        assert {:error, "instra-au already set on DNS host."} ==
                 Domain.modify_dns_record("instra-au", "128.199.156.69")
      end
    end
  end
end
