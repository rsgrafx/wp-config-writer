defmodule Mix.Tasks.WpConfig.Write do
  @shortdoc "Generates a wp-config.php / Nginx conf file with given params"
  use Mix.Task

  @moduledoc """
  This task accepts incoming params and writes a wp-config.php file.

      Usage: mix wp_config.write /var/www/xyz orion-db orion-user password

      Usage: mix wp_config.write nginx /var/www/xyz foobar.com

  """
  alias WpConfigWriter.Build
  alias WpConfigWriter.Build.Nginx
  alias WpConfigWriter.Manage.Domain

  def main(args \\ []) do
    args
    |> OptionParser.parse(strict: [debug: :boolean])
    |> run()
  end

  def run({_, ["configs"], [{"--check", _}]}) do
    IO.puts(
      "An :error - means - either not needed set to '' \n* Double check if this item is needed."
    )

    WpConfigWriter.api_token()
    |> WpConfigWriter.mask()
    |> IO.inspect(label: "Digital Ocean API key: \n")

    IO.inspect(WpConfigWriter.database_configs(), label: "Database configs: \n")
  end

  def run({_, ["nginx", abs_path, domain_name], _}) do
    Nginx.parse_and_write(domain_name, abs_path)
  end

  def run({_, [abs_path, db_name, db_user, db_password], _})
      when nil not in [abs_path, db_name, db_user, db_password] do
    data =
      Build.new(%{
        db_name: db_name,
        db_user: db_user,
        db_password: db_password
      })

    IO.puts("WP config file - setup")
    WpConfigWriter.build_file(abs_path, data)
  end

  def run(_) do
    IO.puts("Please ensure you follow required usage: \n
          e.g. Usage: mix wp_config.write /var/www/xyz orion-db orion-user password \n
          e.g. Setting up Nginx configs \n
          Usage: mix wp_config.write nginx /var/www/path fooobar.com
          ")
    IO.puts("WP config file creating aborted")
  end
end
