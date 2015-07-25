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

  def profile
    @user = User.find_by(params[:user][:pin])
    if @user.password_digest != params[:user][:pin]
      redirect_to session_notice_path
      flash[:notice] = "Pin is not correct."
    else
      session[:user_id] = @user.id
      redirect_to(profile_path(@user))
    end
      
  end

  protected

  def get_user(user_params)
    User.find_or_create_by(phone: user_params[:phone])
  end

  def get_pin(user_pin)
    User.find_by(password_digest: user_pin[:pin])
  end

end
