import Config

config :wp_config_writer, :myxql,
  username: System.get_env("MYSQL_USER"),
  password: System.get_env("MYSQL_PASS"),
  hostname: System.get_env("MYSQL_HOST"),
  port: System.get_env("MYSQL_PORT") || 3306,
  ssl: false

config :wp_config_writer,
       :dns_provider,
       key: System.get_env("DIGITAL_OCEAN_API"),
       ip_address: System.get_env("DNS_IP"),
       current_domain: System.get_env("DOMAIN_SCOPE", "coworkfiji.com"),
       api: "https://api.digitalocean.com/v2/domains"
