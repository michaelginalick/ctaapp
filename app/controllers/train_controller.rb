class TrainController < ApplicationController

	def create
		@user = User.find(session[:user_id])
	end

end

