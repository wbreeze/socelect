# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "socelect"
set :repo_url, "git@github.com:wbreeze/socelect.git"

set :rbenv_type, :user
set :rbenv_ruby, File.read('../.ruby-version').strip
set :rbenv_prefix, <<~PREFIX.gsub("\n", "\s")
  RBENV_ROOT=#{fetch(:rbenv_path)}
  RBENV_VERSION=#{fetch(:rbenv_ruby)}
  #{fetch(:rbenv_path)}/bin/rbenv exec
  PREFIX
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

append :linked_dirs, 'vendor/bundle', '.bundle'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets'
append :linked_dirs, 'public/system', 'public/uploads'
append :linked_files, 'config/master.key'
append :linked_files, 'db/socelect_production.sqlite3'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
