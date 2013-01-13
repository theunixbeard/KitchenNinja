post '/unauthenticated/?' do
  flash[:login_fail] ||= make_alert 'Please login first!'
  redirect '/login'
end

post '/register' do
  logger.info 'post to /register'
  u = User.new
  u.email = params['email']
  u.password_hash_and_salt params['password']
  error = nil
  error_msg = ''
  begin
    u.save
  rescue DataMapper::SaveFailureError => e
    logger.error e.resource.errors.inspect
    logger.error e.resource.errors
    error = e
    if e.resource.errors[:email]
      if e.resource.errors[:email][0] == 'Email is already taken'
        error_msg = 'Sorry! That email address is already in use on Kitchen Ninja!'
      else
        error_msg = 'Sorry! We don\'t recognize that as a valid email address!'
      end
    end
  end
  if error
    flash[:register_fail] = make_alert error_msg 
    erb :register_form  
  else
    redirect user_homepage_link
  end
end

get '/login' do 
  erb :login_form
end

post '/login' do
  #preemptively assume login fail 
  flash[:login_fail] = make_alert 'Bad Username/Password combination, please try again.'
  env['warden'].authenticate!
  if env['warden'].authenticated? 
    #logger.info env['warden'].user
    # This is where we redirect the user to their homepage
    redirect user_homepage_link
  else
    logger.error 'post /login passed through env["warden"].authenticate! yet env["warden"].authenticated? is false!!!'
    redirect '/login'
  end

end

get '/register' do
  erb :register_form
end

get '/logout' do
  env['warden'].logout
  redirect '/'
end

