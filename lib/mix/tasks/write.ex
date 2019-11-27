defmodule Mix.Tasks.WpConfig.Write do
  @shortdoc "Generates a wp-config.php file with given params"
  use Mix.Task

  @moduledoc """
  This task accepts incoming params and writes a wp-config.php file.

      Usage: mix wp_config.write /var/www/xyz orion-db orion-user" password

  """

  def run(args) do
    with {_, [abs_path, db_name, db_user, db_password], _}
         when nil not in [abs_path, db_name, db_user, db_password] <-
           OptionParser.parse(args, strict: [debug: :boolean]) do
      data =
        WpConfigWriter.Build.new(%{
          db_name: db_name,
          db_user: db_user,
          db_password: db_password
        })

      IO.puts("WP config file - setup")
      WpConfigWriter.build_file(abs_path, data)
    else
      _ ->
        IO.puts("Please ensure you follow required usage: \n
          e.g. Usage: mix wp_config.write /var/www/xyz orion-db orion-user password
          ")
        IO.puts("WP config file creating aborted")
    end
  end
end
