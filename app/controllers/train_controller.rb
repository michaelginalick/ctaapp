class TrainController < ApplicationController

  def create
    @user = User.find(session[:user_id])
    create_train
  end

  def destroy
    @stop = Train.find(params[:id])
    @stop.destroy
    redirect_to(profile_path)
  end
end
