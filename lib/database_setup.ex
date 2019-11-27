defmodule WpConfigWriter.DataBase.Setup do
  @moduledoc """
  Setup database.
  """

  require Logger

  def setup_user(user, password, app_database) do
    config = setup_config()

    with {:ok, pid} <- MyXQL.start_link(config),
         queries = build_queries(user, password, app_database),
         %MyXQL.Result{} <- run_queries(pid, queries) do
      {:ok, :success}
    else
      _ ->
        Logger.debug("CONFIG FOR MYSQL NOT SET")
        :error
    end
  end

  defp build_queries(user, password, app_database) do
    first = ~s[create user '#{user}'@'localhost' identified by '#{password}']

    second =
      ~s[create database #{app_database} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci]

    third = ~s[GRANT ALL ON #{app_database}.* TO '#{user}'@'localhost']
    [first, second, third]
  end

  defp run_queries(pid, [first, second, third]) do
    MyXQL.query!(pid, first)
    MyXQL.query!(pid, second)
    MyXQL.query!(pid, third)
  end

  def setup_config do
    Application.get_env(:wp_config_writer, :myxql)
    |> setup()
  end

  defp setup(config) do
    with val when is_binary(val) <- Keyword.get(config, :port) do
      {_, new_config} =
        Keyword.get_and_update(config, :port, fn port ->
          {port, String.to_integer(port)}
        end)

      new_config
    end
  end
end
