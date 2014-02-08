# deadoble.rb

require 'rubygems'
require 'sinatra'
require 'instagram'

enable :sessions

#CALLBACK_URL = "http://localhost:4567/oauth/callback"
CALLBACK_URL = "http://deadoble.herokuapp.com/oauth/callback"

Instagram.configure do |config|
	#Localhost
  #config.client_id = "5ad554a8f9ce40da8b1593291674217d"
  #config.client_secret = "599c6bf03cd9495c98a961686d2dcee8"
  	#Production (Heroku)
  config.client_id = "e02bff1b47e74e42b5792607e26a5fca"
  config.client_secret = "ee3161f28e8042ecaf6a30819ca61594"
end

get "/" do

	html = "<h1>De a doble mamabicho</h1>"
	  for media_item in Instagram.tag_recent_media("deadoble")
	    html << "<img src='#{media_item.images.thumbnail.url}'>"
	  end
  	html

  #'<a href="/oauth/connect">Connect with Instagram</a>'
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/feed"
end

get "/feed" do
  client = Instagram.client(:access_token => session[:access_token])
  #client = Instagram.user_search("sparragus")
  user = client.user

  html = "<h1>De a doble mamabicho</h1>"
  for media_item in Instagram.tag_recent_media("deadoble")
    html << "<img src='#{media_item.images.thumbnail.url}'>"
  end
  html
end


#https://api.instagram.com/v1/tags/nofilter?access_token=ACCESS-TOKEN