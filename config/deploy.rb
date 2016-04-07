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
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`


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
