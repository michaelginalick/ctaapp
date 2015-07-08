module UserHelper
	 def current_user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user != nil
  end

  def create_client
		account_sid = ENV['TWSID']
		auth_token = ENV['TOKEN']
		
		return Twilio::REST::Client.new(account_sid, auth_token)
	end



end
