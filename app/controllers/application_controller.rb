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
                          days: get_days)
    set_time_save_train

    #SendTimes.perform_at(@train.time, @train.id)

    if request.xhr?
      render :json => @train
    end
  end

  def get_days
    if @user.trains.length < 3
      day_string = ''

      params[:days].each_value do |value|
        day_string += value

        return day_string

      end
    else
      flash[:notice] = "Too many trains!"
      redirect_to(profile_path(@user))
    end
    return day_string
  end

  def set_time_save_train
    if Time.now > @train.time
      #reschedule times from the past to the future so they are not run instantly
      @train.time += (60*60*24)
      @train.save!
    end

  end

  def generate_pin_save_user
    pin = (rand * 10000).floor.to_s
    @user.password_digest = pin
    @user.save!
  end


  def assign_session

    if Time.now - @user.created_at < 2 #new users have pin autogenerated
      assign_pin
      session[:user_id] = @user.id
      redirect_to user_path(User.find(session[:user_id])) if session[:user_id] != nil
    else
      flash[:notice] = "Phone number must be unique"
      redirect_to root_psath
    end

  end

  def assign_pin
    pin = rand.to_s.reverse
    pin = pin[0..3]
    @user.password_digest = pin
    @user.save!

    return pin
  end


end
