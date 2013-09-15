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
		likes_response = conn.get params[:friend_uid] + "?fields=music&access_token=" + "CAACNSFC2zdIBALscifGOU7FzeECGO7aYdELyttj6tgLTJrsMvSlZCgg6rKJZBBmFVykgdUsA9EZBh2oZBZCPpn7CZCbAox8wnz8QAfzU1vfTb7bJ4wkbL5BdRRxSNbAdAc55F4tiNRktaHcV8an3gA0CkYrd3J9awz7oObAHfmIgvl6KRZCChb3"#@user.access_token

		require 'json'
		@likes = JSON.parse(likes_response.body)['friends']['data']

		render :action => 'gifting_friend'
	end

end
