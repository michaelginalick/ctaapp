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

	def profile
		@train = Train.new
		@user = User.find(session[:user_id])
		if @user.password_digest == params[:pin]
		end
	end


  def stop
  	@user = User.find(session[:user_id])
  	render :"user/_stops_partial", :layout => false
  end

  def destroy
    @user = User.find(session[:user_id])
    @stop = Train.find(params[:train].values[0].to_i)

    @stop.destroy

    redirect_to(profile_path)
    end

end
