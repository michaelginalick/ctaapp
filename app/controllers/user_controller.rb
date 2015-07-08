class UserController < ApplicationController

	def show
		@user = User.find(session[:user_id])
	end

	def confirm
		@user = User.find(session[:user_id])
		if @user.password_digest == params[:pin]
			redirect_to(user_path(@user))
		end
	end


	def code	
		@user = User.find(session[:user_id])
		pin = (rand * 10000).floor.to_s
		@user.password_digest = pin
		@user.save!

		@client = create_client
		@client.account.messages.create(
			:body => "Message from CTA App:\nYour pin is #{pin}.",
			:to => "+1#{@user.phone}",
			:from => ENV['FROM'])
		redirect_to(user_path(@user))
	end


end
