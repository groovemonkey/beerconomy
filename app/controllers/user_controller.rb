class UserController < ApplicationController
  def home
    @user = current_user
    
    # put the 5 newest beer objects into a collection 
    @beers_given = []

    unless @user.beersGiven.empty?
      @user.beersGiven[-5..-1].each do |b|
        bObj = Beer.find_by id: b
        @beers_given << bObj
      end
    end

    # count received beers
    @received_count = @user.beersReceived.count

    # count offered beers
    @beersOffered = @user.beersOffered.count

    #identity has email addr
    identity = Identity.find(current_user.uid.to_i)
    @email = identity.email
  end

end
