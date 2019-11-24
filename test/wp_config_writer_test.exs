defmodule WpConfigWriterTest do
  use ExUnit.Case

  test "creates a wp-config.php file" do
    WpConfigWriter.build_file("/Applications/MAMP/htdocs/wp-base", "data is foobar")
    assert File.exists?("/Applications/MAMP/htdocs/wp-base/wp-config.php")
  end

  test "writes-define function" do
    assert WpConfigWriter.write_define("DB_NAME", "my-db-name") ==
             "define( 'DB_NAME', 'my-db-name' );"
  end
end
