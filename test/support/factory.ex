defmodule WpConfigWriter.Payload.Factory do
  def all_records_response do
    %{
      "domain_records" => [
        %{
          "data" => "1800",
          "flags" => nil,
          "id" => 55_982_361,
          "name" => "@",
          "port" => nil,
          "priority" => nil,
          "tag" => nil,
          "ttl" => 1800,
          "type" => "SOA",
          "weight" => nil
        },
        %{
          "data" => "128.199.156.69",
          "flags" => nil,
          "id" => 55_982_894,
          "name" => "www",
          "port" => nil,
          "priority" => nil,
          "tag" => nil,
          "ttl" => 3600,
          "type" => "A",
          "weight" => nil
        },
        %{
          "data" => "128.199.156.69",
          "flags" => nil,
          "id" => 83_020_606,
          "name" => "blog",
          "port" => nil,
          "priority" => nil,
          "tag" => nil,
          "ttl" => 3600,
          "type" => "A",
          "weight" => nil
        },
        %{
          "data" => "128.199.156.69",
          "flags" => nil,
          "id" => 84_506_976,
          "name" => "instra-au",
          "port" => nil,
          "priority" => nil,
          "tag" => nil,
          "ttl" => 3600,
          "type" => "A",
          "weight" => nil
        }
      ],
      "links" => %{},
      "meta" => %{"total" => 9}
    }
  end
end
