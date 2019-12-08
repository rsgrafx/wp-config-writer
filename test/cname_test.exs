defmodule WpConfigWriter.Manage.DomainTest do
  use ExUnit.Case

  import ExUnit.CaptureLog
  import Mock

  alias WpConfigWriter.Manage.Domain
  alias WpConfigWriter.Payload.Factory

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

  def post_records(status \\ 201) do
    fn "https://api.digitalocean.com/v2/domains/coworkfiji.com/records", _ ->
      {:ok, %HTTPoison.Response{body: @response, status_code: status}}
    end
  end

  describe "POST new DNS record" do
    test "check?(domain) not on host" do
      with_mock HTTPoison,
        get: fetch_records() do
        assert {:ok, "non-existent-domain"} == Domain.check?("non-existent-domain")

        assert {:error, "instra-au already set on DNS host."} == Domain.check?("instra-au")
      end
    end

    test "ERROR domain already in use" do
      with_mock HTTPoison,
        get: fetch_records(),
        post: post_records() do
        assert {:error, "instra-au already set on DNS host."} ==
                 Domain.modify_dns_record("instra-au", "128.199.156.69")
      end
    end

    test "Error modify_dns_record/2" do
      with_mock HTTPoison,
        get: fetch_records(),
        post: post_records(422) do
        assert {:error, "Unable to fulfill request."} ==
                 Domain.modify_dns_record("unknown-dns", "128.199.156.69")
      end
    end

    test "Error bad inputs modify_dns_record/2" do
      assert_raise WpConfigWriter.Manage.Domain.Error, fn ->
        Domain.modify_dns_record(nil, "")
      end
    end

    test "200 modify_dns_record/1" do
      with_mock HTTPoison,
        get: fetch_records(),
        post: post_records(201) do
        assert Jason.decode(@response) ==
                 Domain.modify_dns_record("my-new-subdomain", "128.199.156.69")
      end
    end
  end
end
