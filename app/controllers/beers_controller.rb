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
        #user.update(beersOffered: [(user.beersOffered << @beer.randID)].flatten)
        user.beersOffered_will_change!
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
      @beer = Beer.find(randID)

      # credit the sender and remove beer from 'beersOffered'
      sponsor = User.find_by uid: @beer.sponsor.to_s
      sponsor.beersGiven_will_change!
      sponsor.beersOffered_will_change!
      sponsor.beersOffered -= [randID]
      sponsor.beersGiven.push(@beer['id'])
      sponsor.save

      # credit the receiver; formerly # current_user.beersReceived.push(beer.id)
      user = current_user
      user.beersReceived_will_change!
      user.beersReceived.push(@beer['id'])
      user.save

      # change the beer's field's (not doing @beer.user = current_user.uid.to_i)
      @beer.recipient = current_user.uid.to_i
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
    sponsor = @beer.user #User.find_by uid: @beer.sponsor.to_s
    recipient = User.find_by uid: @beer.recipient.to_s
    @sponsorname = sponsor.name
    if recipient
      @recipientname = recipient.name
    else
      @recipientname = false
    end

  end

end
