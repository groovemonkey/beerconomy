class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id

    # complete action they were attempting before login
    if session[:action_to_complete] == "create_beer"
      session[:action_to_complete] = nil
      redirect_to new_beer_path

    else
      puts "HOLY CRAP! YOU DONT HAVE AN ACTION TO COMPLETE"
      puts "session keys: #{session.keys}"
      redirect_to '/user/home', notice: "Signed in!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  def failure
    redirect_to root_url, alert: "Authentication failed, please try again."
  end


end