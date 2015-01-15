require 'sinatra'
require 'haml'

get '/' do
  "Hello, World!"
end

get '/about' do
  'A little about me. Ya gamoosa'
end

get '/form' do
  haml :form
end

post '/form' do
  # TODO use js
  "Post Yo dafuc form"
end

get '/secret' do
  haml :secret
end

post '/secret' do
  params[:secret].reverse
end

not_found do
  status 404
  "404, seriously -.-'"
end
