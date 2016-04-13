
# RVM bootstrap
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"

set :rvm_type,        :user
set :rvm_ruby_string, "ree"

# Application setup
set :application, "capdeploy"
set :deploy_to, "/var/www/#{application}"
set :repository,  "git@github.com:chandru-1987/capdeploy.git"
set :scm, :git
set :branch, "master"
set :scm_passphrase, "aspire@123"
set :use_sudo, false
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }
set :keep_releases, 5
#server "172.20.24.23", :app, :web, :db, :primary => true
default_run_options[:pty] = true
set :stages, ["production", "staging"]

task :production do
  role :web, "172.20.33.35", :no_release => true
  role :app, "172.20.33.35"
  role :db , "172.20.33.35", :no_release => true, :primary => true
  set :user, "001086"
  set :password, "april@2016"
  set :rails_env, "production"
end

task :staging do
  role :web, "172.20.33.29", :no_release => true
  role :app, "172.20.33.29"
  role :db , "172.20.33.29", :no_release => true, :primary => true
  set :user, "001087"
  set :password, "Vishnu0205"
  set :rails_env, "staging"
end 

namespace :deploy do
 desc "Symlink shared config files"
 task :symlink_config_files do
   run "#{ try_sudo } ln -s #{ deploy_to }/shared/config/database.yml #{ current_path }/config/database.yml"
 end
 task :setup_config do
   run "mkdir -p #{shared_path}/config"
   put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
   puts "Now edit the config files in #{shared_path}."
 end
end

after "deploy:setup", "deploy:setup_config"
after "deploy:symlink", "deploy:symlink_config_files"
after "deploy", "deploy:cleanup"
