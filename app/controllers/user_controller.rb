class UserController < ApplicationController

  def home
    @user = current_user
    
    # put the 5 newest beer objects into a collection 
    @beers_given = []
    @user.beersGiven.last(5).each do |b|
        bObj = Beer.find_by randID: b
        @beers_given << bObj
    end

    # count received beers
    @received_count = @user.beersReceived.count if @user.beersReceived else 0

    # show offered beers
    @beersOffered = []
    puts @user.beersOffered.inspect

    userbeers = @user.beersOffered || []

    userbeers.each do |b|
      bObj = Beer.find_by randID: b
      @beersOffered << bObj
    end


    #identity has email addr
    identity = Identity.find(current_user.uid.to_i)
    @email = identity.email
  end

end
