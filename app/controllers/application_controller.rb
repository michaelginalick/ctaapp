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

	def train_stuff

   		get_days

      @train = Train.create(stop: params[:stop], 
                            line: params[:line], 
                            user_id: params[:user_id], 
                            time: params[:time].to_time, 
                            days: day_string)
      #SendTimes.perform_at(@train.time, @train.id)
      if request.xhr?
        render :json => @train
      end
    end
  end 

  def get_days
  	 if @user.trains.length < 50
       day_string = ''

        params[:days].each_value do |value|
         day_string += value

         return day_string

        end
      else
      redirect_to(profile_path(@user))
     end	
  end

  def set_time_save_train
  	if Time.now > @train.time
    	#reschedule times from the past to the future so they are not run instantly
      @train.time += (60*60*24) 
      @train.save!
    end

  end


end
