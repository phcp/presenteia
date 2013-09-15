class HomeController < ApplicationController
	
	def index
		if session.has_key? :user_id
			@user = User.find_by_id(session[:user_id])
			friends_list
		end
	end

	def friends_list
		conn = Faraday.new(:url => 'https://graph.facebook.com/') do |faraday|
			faraday.request  :url_encoded
			faraday.response :logger
			faraday.adapter  Faraday.default_adapter
		end

		@user = User.find_by_id(session[:user_id])

		friends_response = conn.get @user.uid + "?fields=friends.fields(id,name,picture)&access_token=" + @user.access_token

		require 'json'
		@friends = JSON.parse(friends_response.body)['friends']['data']

		render :action => 'friends_list'
	end

	def get_friend_likes
		conn = Faraday.new(:url => 'https://graph.facebook.com/') do |faraday|
			faraday.request  :url_encoded
			faraday.response :logger
			faraday.adapter  Faraday.default_adapter
		end

		@user = User.find_by_id(session[:user_id])
		likes_response = conn.get params[:friend_uid] + "?fields=name,music&access_token=" + @user.access_token

		require 'json'
		@friend_likes = JSON.parse(likes_response.body)['music']['data']
		@friend_name = JSON.parse(likes_response.body)['name']

		render :action => 'gifting_friend'
	end

end
