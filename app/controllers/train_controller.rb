class TrainController < ApplicationController

  def create
    if @user.trains.length < 3
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

      "Stop added!"
    else
      "Limit of three train stops exceeded!"
    end
  end

end
