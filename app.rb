require 'sinatra'
require 'haml'
require 'sinatra/partial'

set :haml, layout: true

get '/' do
 haml "Hello, World!!!"
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
