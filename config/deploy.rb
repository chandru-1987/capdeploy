require "rvm/capistrano"

set :rvm_type,        :user
set :rvm_ruby_string, "ruby-2.1.6"
set :application, "dialedin"
set :user, "001086"
set :deploy_to, "/var/www/#{application}"
set :repository,  "git@github.com:chandru-1987/capdeploy.git"
set :scm, :git
set :branch, "master"
set :scm_passphrase, "aspire@123"
set :use_sudo, false
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }
set :keep_releases, 5
server "172.20.24.23", :app, :web, :db, :primary => true
default_run_options[:pty] = true

namespace :deploy do

 desc "Start Passenger app"
 task :start do
    run "rails s"
 end 

 desc "Restart Passenger app"
 task :restart  do
   #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   run  "rails s"
 end

 desc "Symlink shared config files"
 task :symlink_config_files do
   run "#{ try_sudo } ln -s #{ deploy_to }/shared/config/database.yml #{ current_path }/config/database.yml"
 end

 task :setup_config do
   run "mkdir -p #{shared_path}/config"
   put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
   puts "Now edit the config files in #{shared_path}."
 end

 task :precompile_assets do
   run "cd #{latest_release}; bundle exec rake assets:precompile"
 end

 task :migrate do
   run "cd #{latest_release}; bundle exec rake db:create; bundle exec rake db:migrate"
 end

end

after "deploy:setup", "deploy:setup_config"
after "deploy", "deploy:cleanup"
after "deploy:migrations" , "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_config_files"
after "deploy:update_code", "deploy:precompile_assets"
