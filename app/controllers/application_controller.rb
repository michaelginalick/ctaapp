class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper :all

 

  def create_client
		account_sid = ENV['TWSID']
		auth_token = ENV['TOKEN']
		
		return Twilio::REST::Client.new(account_sid, auth_token)
	end

end
