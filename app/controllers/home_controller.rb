class HomeController < ApplicationController
	
	def index
		if session.has_key? :user_id
			@user = User.find_by_id(session[:user_id])
			gifting
		end
	end

	def gifting
		conn = Faraday.new(:url => 'https://graph.facebook.com/') do |faraday|
			faraday.request  :url_encoded
			faraday.response :logger
			faraday.adapter  Faraday.default_adapter
		end

		@user = User.find_by_id(session[:user_id])

		friends_response = conn.get @user.uid + "?fields=friends.fields(id,name,picture)&access_token=" + @user.access_token

		require 'json'
		@friends = JSON.parse(friends_response.body)['friends']['data']

		render :action => 'gifting'
	end

	def list_likes(friend_uid)
		conn = Faraday.new(:url => 'https://graph.facebook.com/') do |faraday|
			faraday.request  :url_encoded
			faraday.response :logger
			faraday.adapter  Faraday.default_adapter
		end

		@user = User.find_by_id(session[:user_id])
		likes_response = conn.get friend_uid + "/music&access_token=" + @user.access_token
	end

end
