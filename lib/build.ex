defmodule WpConfigWriter.Build do
  @moduledoc """

  define( 'DB_NAME', 'database_name_here' );

  /** MySQL database username */
  define( 'DB_USER', 'username_here' );

  /** MySQL database password */
  define( 'DB_PASSWORD', 'password_here' );

  /** MySQL hostname */
  define( 'DB_HOST', 'localhost' );

  /** Database Charset to use in creating database tables. */
  define( 'DB_CHARSET', 'utf8' );

  /** The Database Collate type. Don't change this if in doubt. */
  define( 'DB_COLLATE', '' );
  """

  defstruct [
    :db_name,
    :db_user,
    :db_password,
    db_host: "localhost",
    db_charset: "utf8",
    db_collate: ""
  ]

  def new(%{db_name: _, db_user: _, db_password: _} = creds) do
    %HTTPoison.Response{body: salt_body} = get_salt(Mix.env())
    define_list = build_define_list(struct(__MODULE__, creds))
    compose(["<?php \n", [define_list, salt_body, base_required()]])
  end

  defp compose(list) do
    Enum.join(list, "\n")
  end

  def get_salt(:prod) do
    with {:ok, %{status_code: 200} = data} =
           HTTPoison.get("https://api.wordpress.org/secret-key/1.1/salt/") do
      data
    end
  end

  def get_salt(_) do
    %HTTPoison.Response{
      body:
        "define('AUTH_KEY', 'x:1;.{jFrK+a,O&FF[c|9kXy,H_,^5_e90n_]in|byDLkc%t0OC<$ |qarfo(+u|');\ndefine('SECURE_AUTH_KEY',  '`aP`/Y~aqJw-C|.C3.?*X09X!T?s<29^n5hx&>@V74Iv<{G7#3KX#v+:yK&u_20d');\ndefine('LOGGED_IN_KEY',    'K|~EKS!.SJ*>e}$&fStr?nq#R)02qYq7M;0sm5K8nccP-&0-,.kaw=75@j;hk(uM');\ndefine('NONCE_KEY',        'dsQw}{mTRt.|M3v<->b[>G)i(`3D~rU/!4FlTkfl@^-,JyFKSopm5z1`WIttBG#+');\ndefine('AUTH_SALT',        'E9*6Xx5d>&20Xf=~,I-0MKQ4w7Y~z~d+&oBI;F(H?xQL y#d|n=qZ5pJ.m(}Nr.I');\ndefine('SECURE_AUTH_SALT', 'yR HpeB5[{<Z79JZ>>DsqN~<>p>Ont8 ,Jk;1f[#[^x-lFH~-|A*dC +j2uwI.9c');\ndefine('LOGGED_IN_SALT',   '7!R+,=Q!&]nkT>6pVFwS0/}_PUz&&jGF{R#~<C/`-[R-nZW/!@ofEaWw2}GJi~{ ');\ndefine('NONCE_SALT',       '+Nx-KGUjm/{0]_jJ2 #n$+YVu+p`en)}TEIu?@N~.%5_7tpT+-+DVXc;(N l:H7T');\n",
      headers: [
        {"Server", "nginx"},
        {"Date", "Sun, 24 Nov 2019 22:31:13 GMT"},
        {"Content-Type", "text/plain;charset=utf-8"},
        {"Transfer-Encoding", "chunked"},
        {"Connection", "keep-alive"},
        {"X-Frame-Options", "SAMEORIGIN"}
      ],
      request: %HTTPoison.Request{
        body: "",
        headers: [],
        method: :get,
        options: [],
        params: %{},
        url: "https://api.wordpress.org/secret-key/1.1/salt/"
      },
      request_url: "https://api.wordpress.org/secret-key/1.1/salt/",
      status_code: 200
    }
  end

  def base_required do
    ~S"""
    $table_prefix = 'wp_';

    define( 'WP_DEBUG', false );

    /* That's all, stop editing! Happy publishing. */

    /** Absolute path to the WordPress directory. */
    if ( ! defined( 'ABSPATH' ) ) {
      define( 'ABSPATH', dirname( __FILE__ ) . '/' );
    }

    /** Sets up WordPress vars and included files. */
    require_once( ABSPATH . 'wp-settings.php' );
    """
  end

  def build_define_list(data) do
    for {key, v} <- Map.from_struct(data) do
      key |> to_string() |> String.upcase() |> define(v)
    end
  end

  def define(param, key) do
    "define( '#{param}', '#{key}' ); \n"
  end
end
