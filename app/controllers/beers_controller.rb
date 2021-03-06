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
        recipient: params[:recipient],
        note: params[:note],
        lat: request_geo_lat,
        lon: request_get_lon,
        receivedAt: nil
      )

      if @beer.save
        #user.update(beersOffered: [(user.beersOffered << @beer.randID)].flatten)

        # TODO fix default values in DB
        user.beersOffered_will_change!
        if user.beersOffered == nil
          user.beersOffered = []
        end

        user.beersOffered.push(@beer.randID)
        user.save
        redirect_to @beer
      else
        redirect_to new_beer_path, notice: "There were some problems saving your beer..."
      end

    # user is not logged in
    else
      # save beer in SESSION
      session[:beer_to_submit] = { 
        recipient: params[:recipient],
        note: params[:note]
      }
      session[:action_to_complete] = :create_beer

      # go to login screen
      redirect_to "/sessions/new"
    end

  end


  def redeem()
    if request.method == "POST"
      return redirect_to receivebeer_path(randID: request.params['beerID']) 
    end
    return
  end


  def receive()
    # beer comes in as a random ID, shared through a link OUTSIDE the app
    randID = params[:randID]

    # LOGGED IN USERS:
    if current_user

      # clear session option, if it was used as part of a login redirect
      if session[:beer_to_submit]
        session[:beer_to_submit] = nil
      end

      timenow = Time.now()
      begin
        @beer = Beer.find(randID)
      rescue
        return redirect_to redeem_beer_path, notice: "Sorry, there's no such beer. Did you paste the beer ID correctly?"
      end

      # has this beer already been received?
      if @beer.receivedAt
        return redirect_to showbeer_path({id: randID}), notice: "This beer has already been accepted"
      end

      # is this the user that created the beer?
      if current_user.beersOffered.include?(randID)
        return redirect_to user_home_path, notice: "You can't accept your own beer. Go find some friends!"
      end



      # credit the sender and remove beer from 'beersOffered'
      sponsor = User.find_by uid: @beer.sponsor.to_s

      # TODO fix default values in DB
      sponsor.beersGiven_will_change!
      if sponsor.beersGiven == nil
        sponsor.beersGiven = []
      end

      sponsor.beersOffered_will_change!
      sponsor.beersOffered -= [randID]
      sponsor.beersGiven.push(@beer['id'])
      sponsor.save

      # credit the receiver; formerly # current_user.beersReceived.push(beer.id)
      user = current_user
      user.beersReceived_will_change!
      user.beersReceived.push(@beer['id'])
      user.save

      # change the beer's fields
      @beer.user_id = current_user.uid.to_i
      @beer.receivedAt = timenow
      @beer.save

      # set more vars for view
      @sponsorname = sponsor.name

    # user is not logged in
    else
      session[:beer_to_receive] = randID
      session[:action_to_complete] = :receive_beer

      # go to login screen
      redirect_to "/sessions/new"
    end
  end


  def new
    @beer = Beer.new()
  end


  def show
    @beer = Beer.find(params[:id])
    sponsor = User.find_by uid: @beer.sponsor.to_s
    @sponsorname = sponsor.name
  end
  

  def index
    # take the last 15 received Beers
    @beers = Beer.order(receivedAt: :desc).where.not(receivedAt: nil).limit(15)
  end

end
