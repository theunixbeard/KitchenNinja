
require 'rubygems'
require 'bundler/setup' #Clears all gems from the load path EXCEPT those in the Gemfile
require 'sinatra'
require 'rack-flash'
require 'data_mapper'
require_relative './config/database'
require 'warden'

configure do
  #enable :sessions # Removed to use Rack::Session::Cookie directly instead due to Warden
  set :environment, :development
end

configure :production do
  set :the_env, 'WE IN PROD FOO'
end

configure :development do
  set :the_env, "WE IN DEV FOO"
end

# helper methods
require_relative './helpers.rb'

# login routes
require_relative './routes/login_routes.rb'

# non-logged-in routes
require_relative './routes/nonloggedin_routes.rb'

# logged-in routes
require_relative './routes/loggedin_routes.rb'

# mixed behavior routes
require_relative './routes/mixed_behavior_routes.rb'

