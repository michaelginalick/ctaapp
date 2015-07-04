class SessionController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def notice
	end

  def index
    redirect_to user_path(User.find(session[:user_id])) if session[:user_id] != nil
  end

  def first
  end

  def login
    @user = get_user(params[:user])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      flash[:notice] = "Invalid username or password"
      redirect_to root_path
    end
  end

  def logout
    session.clear
    flash[:notice] = "See you next time."
    redirect_to root_path
  end

  protected

  def get_user(user_params)
    User.find_by(email: user_params[:email])
  end
	
end
