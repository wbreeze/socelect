set :user, 'socelect'
set :domain, 'socelect.com'
set :application, 'socelect'
set :repository,  "#{user}@#{domain}:git/socelect.git"
set :deploy_to, "/home/#{user}/#{domain}"

set :scm, :git

role :web, domain
role :app, domain
role :db, domain, :primary => true

set :deploy_via, :remote_cache
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :group_writeable, false
set :keep_releases, 2
set :runner, nil

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
   #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   #from site5 capistrano config:
   run "cd /home/#{user}; rm -rf public_html; ln -s #{current_path}/public ./public_html"
   run "skill -9 -u #{user} -c dispatch.fcgi"
  end
end

# try after deploy to enable passenger
# echo -e "PassengerEnabled On\nPassengerAppRoot #{release_path}" > #{release_path}/public/.htaccess

# reconfigure databases
# after "deploy:update_code", :bundle_install
# desc "install the necessary prerequisites"
# task :bundle_install, :roles => :app do
#   run "cd #{release_path} && bundle install"
# end

