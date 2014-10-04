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

    elsif session[:action_to_complete] == "receive_beer"
      session[:action_to_complete] = nil
      redirect_to receivebeer_path(session[:beer_to_receive])

    else
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