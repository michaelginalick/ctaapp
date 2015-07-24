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
		generate_pin_save_user
		@client = create_client
	
		@client.account.messages.create(
			:body => "Message from CTA App:\nYour pin is #{assign_pin}.",
			:to => "+1#{@user.phone}",
			:from => ENV['FROM'])
		
		redirect_to(user_path(@user))
	end

	def profile
			@train = Train.new
			@user = User.find(session[:user_id])
			if @user.password_digest != params[:pin] 
				redirect_to session_notice_path
				flash[:notice] = "Pin is not correct."
			end
	end

  def stop
  	@user = User.find(session[:user_id])
  	render :"user/_stops_partial", :layout => false
  end

  def destroy
    @user = User.find(session[:user_id])
		if request.xhr?
        render :json => @user
    end
  end

  def delete
  	@user = User.destroy(session[:user_id])
  	session.clear
  	redirect_to root_path
  end

   def logout
    session.clear
    flash[:notice] = "See you next time."
    redirect_to root_path
  end


end
