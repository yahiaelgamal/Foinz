require 'sinatra'
require 'haml'
require 'omniauth'
require 'koala'
require 'sinatra/partial'
require 'awesome_print'
require 'byebug'
require 'mongoid'


Dir.glob('./models/*.rb').each { |file| require file }
Dir.glob('./helpers/*.rb').each { |file| require file }

Mongoid.load!("config/mongoid.yml", ENV['RACK_ENV'])

# AUTHENTCATION FACEBOOK
APP_ID     = 306913702832623
APP_SECRET = '3e2b50f67f7d8ee2d38ef3f1944855ea'

#use Rack::Session::Cookie, secret: 'elsa7elda7emboo'
enable :sessions  unless test?

set :haml, layout: true

get '/' do
 haml :home
end

get '/about' do
  haml 'A little about me. Ya gamoosa'
end

get '/form' do
  haml :form
end

post '/form' do
  # TODO use js
  haml "Post Yo dafuc form"
end

get '/secret' do
  haml :secret#, layout: :layout
end

post '/secret' do
  params[:secret].reverse
end

not_found do
  status 404
  haml "404, seriously -.-'"
end

################################ AUTHENTICATION ###############################
get '/login' do
  # generate a new oauth object with your app data and your callback url
  session['oauth'] = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET,
                                                "#{request.base_url}/callback")
  # redirect to facebook to get your code
  redirect session['oauth'].url_for_oauth_code(permissions: 'email')
end

get '/logout' do
  session.delete('oauth')
  session.delete('current_user')
  redirect '/'
end

# method to handle the redirect from facebook back to you
get '/callback' do
  #get the access token from facebook with your code
  token = session['oauth'].get_access_token(params[:code])
  @graph = Koala::Facebook::API.new(token)
  profile = @graph.get_object("me")
  user = User.create_user_from_fb(profile, token)
  session['current_user'] = user
  redirect '/'
end
################################ AUTHENTICATION END ###########################
