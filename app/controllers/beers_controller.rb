class BeersController < ApplicationController
  

  def create
    @beer = Beer.new(params[:beer])
    if @beer.save
      redirect_to @beer
    else
      redirect_to new_beer_path, notice: "There were some problems saving your beer..."
    end
  end

  def new
    # if method == POST
    if request.method == 'POST'

      # LOGGED IN?
      if current_user
        # create the beer
        @user = current_user
        usr_email = Identity.find(current_user.uid.to_i).email

        request_geo_lat = nil
        request_get_lon = nil

        @beer = @user.beers.build(
          sponsor: @user.uid,
          recipient: params['beer']['name'],
          note: params['beer']['note'],
          lat: request_geo_lat,
          lon: request_get_lon,
          #randID: "TODO: random hash is created in the MODEL",
          receivedAt: nil
        )

      # user is not logged in
      else
        # TODO: save beer in SESSION
        session[:beer_to_submit] = params[:beer]

        # go to login screen
        redirect_to "/sessions/new"
      end


    elsif request.method == 'GET'
      # check if there's a beer in SESSION, use those values if applicable
      if session[:beer_to_submit]
        # build the beer object and (hopefully) fill form
        @beer = Beer.new(session[:beer_to_submit])
      # else give a blank form
      else
        @beer = Beer.new()
      end

    end
  end


  def show
    @beer = Beer.find(params[:id])
  end

end
