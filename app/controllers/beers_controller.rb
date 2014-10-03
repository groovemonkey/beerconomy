class BeersController < ApplicationController
  

  def create
    # clear values if they exist -- this doesn't clear the value if beer-creation is abandoned
    ##session[:beer_to_submit] = nil

    # LOGGED IN?
    if current_user
      # create the beer
      user = current_user
      usr_email = Identity.find(current_user.uid.to_i).email

      request_geo_lat = nil
      request_get_lon = nil

      @beer = user.beers.build(
        sponsor: user.uid,
        recipient: params[:name],
        note: params[:note],
        lat: request_geo_lat,
        lon: request_get_lon,
        receivedAt: nil
      )

      if @beer.save
        redirect_to @beer
      else
        redirect_to new_beer_path, notice: "There were some problems saving your beer..."
      end

    # user is not logged in
    else
      # TODO: save beer in SESSION
      session[:beer_to_submit] = { 
        recipient: params[:recipient],
        note: params[:note]
      }
      session[:action_to_complete] = :create_beer

      # go to login screen
      redirect_to "/sessions/new"
    end

  end


  def new
    @beer = Beer.new()
  end


  def show
    @beer = Beer.find(params[:id])
  end

end
