class TrainController < ApplicationController

  def create
    @user = User.find(session[:user_id])

    if @user.trains.length < 50
       day_string = ''

        params[:days].each_value do |value|
         day_string += value
        end

      @train = Train.create(stop: params[:stop], 
                            line: params[:line], 
                            user_id: params[:user_id], 
                            time: params[:time].to_time, 
                            days: day_string)

      if Time.now > @train.time
        #reschedule times from the past to the future so they are not run instantly
        @train.time += (60*60*24) 
        @train.save!
      end
      #SendTimes.perform_at(@train.time, @train.id)
      if request.xhr?
        render :json => @train
      end
    else
      redirect_to(profile_path(@user))
    end

  end

  def destroy
    @stop = Train.find(params[:id])
    @stop.destroy
    redirect_to(profile_path)
  end
end
