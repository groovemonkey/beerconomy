class UserController < ApplicationController
  
  def last5(coll)
    if coll.count < 5
      return coll
    else
      return coll[-5..-1]
    end
  end


  def home
    @user = current_user
    
    # put the 5 newest beer objects into a collection 
    @beers_given = []
    last5(@user.beersGiven).each do |b|
        bObj = Beer.find_by id: b
        @beers_given << bObj
    end

    # count received beers
    @received_count = @user.beersReceived.count

    # show offered beers
    @beersOffered = []
    @user.beersOffered.each do |b|
      bObj = Beer.find_by randID: b
      @beersOffered << bObj
    end

    #identity has email addr
    identity = Identity.find(current_user.uid.to_i)
    @email = identity.email
  end

end
