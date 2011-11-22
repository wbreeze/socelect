set :user, 'socelect'
set :domain, 'socelect.com'
set :application, 'socelect'
set :repository,  "#{user}@#{domain}:~/git/#{application}.git"
set :deploy_to, "/home/#{user}/#{application}"
default_run_options[:pty] = true

set :scm, :git

role :web, domain
role :app, domain
role :db, domain, :primary => true

set :deploy_via, :remote_cache
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

# enable passenger
after "deploy:symlink", :enable_passenger
desc "setup .htaccess for passenger"
task :enable_passenger, :roles => :app do
  run "echo -e \"PassengerEnabled On\\nPassengerAppRoot #{current_path}\" > #{File.join(current_path, 'public', '.htaccess')}"
  run "rm -f ~/public_html && ln -s #{File.join(current_path, 'public')} ~/public_html"
end

after "deploy:update_code", :bundle_install
desc "install the gems from Gemfile.lock"
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install --deployment"
end

