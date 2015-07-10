class TrainController < ApplicationController

  def create
  	@user = User.find(session[:user_id])

    if @user.trains.length < 50
      day_string = ''

      params[:days].each_value do |value|
        day_string += value
      end

      @train = Train.create(stop: params[:stop], line: params[:line], user_id: params[:user_id], time: params[:time].to_time, days: day_string)

      if Time.now > @train.time
        @train.time += (60*60*24) #reschedule times from the past to the future so they are not run instantly
        @train.save!
      end

      #SendTimes.perform_at(@train.time, @train.id)


    if request.xhr?
      render :json => @train
    end


      "Stop added!"

      #redirect_to(profile_path(@user))

    else
    	redirect_to(profile_path(@user))
      "Limit of three train stops exceeded!"
    end

    def destroy
    	@user = User.find(session[:user_id])
    	@stop = Train.find(user_id: @user, train: params[:train])

    	@stop.destroy

    	redirect_to(profile_path(@user))
    end




  end









end
