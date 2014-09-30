class UserController < ApplicationController
  def home
    @user = current_user
    #@beers_given = @user.beersGiven

    #identity has email addr
    identity = Identity.find(current_user.uid.to_i)
    @email = identity.email
  end


  def give_beer
    # moved all this shit to beers_controller/new
  end


  def receive_beer
    # beer comes in as a random ID, shared through a link OUTSIDE the app
    beer = Beer.find_by randID: params[:beerID]

    # credit the sender and the receiver
    sponsor = User.find_by uid: beer.sponsor
    sponsor.beersGiven.push(beer.randID)

    # change the beer's owner
    beer.receiver = current_user.uid
    current_user.beersReceived.push(beer.randID)

  end

  def new
  end

  def edit
  end
end
