class HomeController < ApplicationController
  def index
    if session.has_key? :user_id
      @user = User.find_by_id(session[:user_id])
      friends_list
    end
  end

  def friends_list
    @user = User.find_by_id(session[:user_id])
    friends_response = get_friends(@user)

    @friends = JSON.parse(friends_response.body)['friends']['data']

    render :action => 'friends_list'
  end

  def get_friend_likes
    @user = User.find_by_id(session[:user_id])
    likes_response = get_likes(params[:friend_uid], @user)

    unless likes_response.body['music'].nil?
      @friend_likes = JSON.parse(likes_response.body)['music']['data']
      @friend_recomendation = Band.get_recommendation(@friend_likes).try(:shuffle!)
    end

    @friend_name = JSON.parse(likes_response.body)['name']

    render :action => 'gifting_friend'
  end

  private

  def get_friends(user)
    conn = create_connection
    conn.get user.uid + "?fields=friends.fields(id,name,picture)&access_token=" + user.access_token
  end

  def get_likes(friend_id, user)
    conn = create_connection
    likes_response = conn.get friend_id + "?fields=name,music&access_token=" + user.access_token
  end

  def create_connection
    conn = Faraday.new(:url => 'https://graph.facebook.com/') do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end
end
