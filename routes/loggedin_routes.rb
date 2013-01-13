before '/secure/*' do
  env['warden'].authenticate!
  #should the below be here? seems authenticate! kicks out to /unauthenticated...
  if env['warden'].authenticated?
    #logger.info env['warden'].user
    'we authenticated!'
  else
    'nah nah nah u aint authenticated'
  end
#  if !session[:identity] then
#    session[:previous_url] = request['REQUEST_PATH']
#    @error = 'Sorry guacamole, you need to be logged in to do that'
#    halt erb(:login_form)
#  end
end

get '/secure/*' do
  erb "This is a secret place that only <%=env['warden'].user.email%> has access to!"
end

# user homepage
get '/u/:id' do
  env['warden'].authenticate!
  erb :user_homepage
end
