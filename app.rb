
require 'rubygems'
require 'bundler/setup' #Clears all gems from the load path EXCEPT those in the Gemfile
require 'sinatra'
require 'data_mapper'
require_relative './config/database'
require 'warden'

configure do
  enable :sessions
  set :environment, :development
end

configure :production do
  set :the_env, 'WE IN PROD FOO'
end

configure :development do
  set :the_env, "WE IN DEV FOO"
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Login/Register'
  end

  def login_menu
    if ! session[:identity]
      '<li><a href="/login">Login</a></li>' +
      '<li><a href="/register">Register</a></li>'
    else
      '<li><a href="/logout">Logout</a></li>'
    end
  end
  end

before '/secure/*' do
  if !session[:identity] then
    session[:previous_url] = request['REQUEST_PATH']
    @error = 'Sorry guacamole, you need to be logged in to do that'
    halt erb(:login_form)
  end
end

get '/' do
  erb 'Can you handle a <a href="/secure/place">secret</a>?'
end

get '/test' do
  'woot'
end

get '/contact' do
  erb :contact
end

get '/about' do
  erb :about
end

get'/test' do
  erb :marketing_narrow
end

get '/login' do 
  erb :login_form
end

post '/login' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from 
end

get '/register' do 
  erb :register_form
end

get '/zzz/hey' do
  User.all.each do |u|
    'hey nonny nonny'
    u.email
  end
end

post '/register' do
  logger.info 'post to /register'
  u = User.new
  u.email = params['email']
  u.password_hash_and_salt params['password']
  begin
    u.save
  rescue DataMapper::SaveFailureError => e
    logger.error e.resource.errors.inspect
  end
  logger.info User.class
  logger.info User.all.class
  User.all.each do |user|
    logger.info user.inspect
  end
  'blah'
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end


get '/secure/place' do
  erb "This is a secret place that only <%=session[:identity]%> has access to!"
end
