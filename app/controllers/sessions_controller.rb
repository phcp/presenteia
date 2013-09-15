# encoding: UTF-8
class SessionsController < ApplicationController

	def create
		auth = request.env["omniauth.auth"]
		@user = User.find_or_create_with_omniauth(auth)
		session[:user_id] = @user.id

		redirect_to return_path || root_path
	end

	def failure
		render :action => 'index', :notice => "Erro!"
	end

	def destroy
		session[:user_id] = nil
		render :action => 'index', :notice => "Volte em breve!"
	end
	def return_path
		request.env['omniauth.origin']
	end

end