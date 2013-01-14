helpers do

  def login_menu_options
    html = ''
    if !env['warden'].authenticated?
      html << '<li><a href="/login">Sign in</a></li>'
      html << '<li><a href="/register">Register</a></li>'
    else
      html << '<li><a href="/logout">Sign out</a></li>'
    end 
  end 

  def header_menu
  html = ''
  if env['warden'].authenticated?
    html << '<li class="active"><a href="' + user_homepage_link + '">Home</a></li>'
  else
    html << '<li class="active"><a href="/">Home</a></li>'
  end
  html << '<li><a href="/about">About</a></li>'
  html << '<li><a href="/contact">Contact</a></li>'
  html << '<li><a href="/blog">Blog</a></li>'
  html << '<li><a href="/secure/place">Secret</a></li>'
    html << '<li class="dropdown">'
    html << '<a href="#" '
          html << 'class="dropdown-toggle"'
          html << 'data-toggle="dropdown">'
          # menu title
          if env['warden'].authenticated?
            html << env['warden'].user.email
          else
            html << 'Sign in/Register'
          end 
          html << '<b class="caret"></b>'
    html << '</a>'
    # dropdown menu options
    html << '<ul class="dropdown-menu">'
      html << login_menu_options
    html << '</ul>'
  html << '</li>'
  end 

  def make_alert message
    html = ''
    html << '<div class="alert">'
    html << '<button type="button" class="close" data-dismiss="alert">&times;</button>'
    html << message
    html << '</div>'
  end

  def user_homepage_link
    # add in error checking if no user!!!
    if env['warden'].authenticated?
      '/u/' + env['warden'].user.id.to_s
    else
      logger.error 'Trying to access user_homepage_link with no logged in user'
      '#bad_link_accessed'
    end
  end

end
