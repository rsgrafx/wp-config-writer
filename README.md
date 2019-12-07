# Wordpress Config Writer

## What it does.

The `wp_config_writer` accepts several command line parameters and uses it to generate an nginx.conf and a wp-config.php file
which are prepopulated with config details needed by wordpress.  Automating wordpress installations.

This can be then be used to setup multiple wordpress installations on a given ubuntu machine without the hassle of 
going thru the same setup every time.  I make no claims that this is perfect software. Software As-Is.
  
*  `wp_config_writer $(BASE_DIR) $(NEW_DATABASE) $(NEW_USER) $(DBPASS)`  \
e.g. usage.
    -  `wp_config_writer /var/www/myapp my_app_database myusername DB>$!PAS$W0RD` 

  - BASE_DIR - being the directory - root directory to wordpress
  - NEW_DATABASE - the mysql database name.
  - NEW_USER - the database user.
  - DBPASS - the database password.

## _wp_config_writer & Nginx_

Usage for generating Nginx Configs - The executable will generate an nginx config with the following params.

- BASE_DIR - where nginx will server your app from.
- SUBDOMAIN - initial subdomain for testing.
- **TODO**: setup a CLI to accept and fully qualified domain.

`wp_config_writer BASE_DIR SUB_DOMAIN`

## _Requirements For Wordpress_

[Proper Digial Ocean Instructions](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-ubuntu-18-04)
This is a great write up with all the details needed for the setup needed to run wordpress.

- PHP \
  `$ sudo apt-get install php-fpm`
  * Find neccerary documentation that helps with your ubuntu installation.
  This app was tested against `PHP 7.2.24-0ubuntu0.18.04.1 (cli) (built: Oct 28 2019 12:07:07) ( NTS )`
  
- Mysql - Setup Mysql \
  `$ sudo apt install mysql-server`  \
  `$ sudo mysql_secure_installation` : Follow instructions
  
- Nginx 

- ### Connecting the PHP & Mysql
  `sudo apt-get install php-mysql`

## _Requirements for Elixir `wp_config_writer` Executable_

- Erlang / Elixir 
  Most bare ubuntu installations on Hosting providers do not have Erlang or Elixir isntalled.
  `(sudo)? apt-get update elixir`

This applicaiton is compiled into an executable on an Ubuntu server
* Name of executable `wp_config_writer` - PATH should be setup in $PATH 

## _Executable Installation_

  > Clone this repository. \
  > `cd wp_config_writer` \
  > `make build-script` - runs mix escript.build

  > Updating - run `make rebuild`

