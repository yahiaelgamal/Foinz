require 'sinatra'
require 'haml'
require 'omniauth'
require 'koala'
require 'sinatra/partial'
require 'awesome_print'
require 'mongoid'


Dir.glob('./models/*.rb').each { |file| require file }

Mongoid.load!("config/mongoid.yml", ENV['RACK_ENV'])

# AUTHENTCATION FACEBOOK
APP_ID     = 306913702832623
APP_SECRET = '3e2b50f67f7d8ee2d38ef3f1944855ea'

use Rack::Session::Cookie, secret: 'elsa7elda7emboo'
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
  redirect session['oauth'].url_for_oauth_code()
end

get '/logout' do
  session['oauth'] = nil
  session['access_token'] = nil
  redirect '/'
end

# method to handle the redirect from facebook back to you
get '/callback' do
  #get the access token from facebook with your code
  session['access_token'] = session['oauth'].get_access_token(params[:code])
  @graph = Koala::Facebook::API.new(session['access_token'])
  profile = @graph.get_object("me")
  User.create_user_from_fb(profile, session['access_token'])
  redirect '/'
end
################################ AUTHENTICATION END ###########################
