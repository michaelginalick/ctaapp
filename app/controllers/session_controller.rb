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
    assign_session
  end



  protected

  def get_user(user_params)
    User.find_or_create_by(phone: user_params[:phone])
  end
	
end
