set :user, 'socelect'
set :domain, 'socelect.com'
set :application, 'socelect'
set :repository,  "#{user}@174.120.16.66:git/socelect.git"
set :deploy_to, "/home/#{user}/#{domain}"

set :scm, :git

role :web, '174.120.16.66'
role :app, '174.120.16.66'
role :db, '174.120.16.66', :primary => true

set :deploy_via, :remote_cache
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
