class UserController < ApplicationController

	def profile 
		'/users/:user_id'
		@user = User.find(params[:user_id])
		redirect '/login' unless @user.logged_in?(session) && session[:confirmed]
		erb :"user/profile"
	end

	def confirm
	 '/users/:user_id/confirm'
		erb :"user/confirm"
	end

	def confirm
	post '/users/:user_id/confirm'
		if @user.password == params[:pin]
			session[:confirmed] = true
			halt 200, "/users/#{@user.id}"
		else
			halt 400, "Pin is incorrect."
		end
	end

	def profile	
	post '/users/:user_id/code'
		pin = (rand * 10000).floor.to_s
		@user.password = pin
		@user.save!

		@client = create_client
		@client.account.messages.create(
			:body => "Message from RightOnTracker:\nYour pin is #{pin}.",
			:to => "+1#{@user.phone}",
		:from => ENV['TWILIO_NUMBER'])

		halt 200, "Pin sent!"
	end


end
