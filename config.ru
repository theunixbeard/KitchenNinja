require ::File.join( ::File.dirname(__FILE__), 'app' )

run Sinatra::Application

# To use thin as the server, uncomment thin line in Gemfile, then run 'thin -R config.ru start'
