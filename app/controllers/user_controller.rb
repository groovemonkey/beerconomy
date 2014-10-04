class UserController < ApplicationController
  def home
    @user = current_user
    #@beers_given = @user.beersGiven

    #identity has email addr
    identity = Identity.find(current_user.uid.to_i)
    @email = identity.email
  end

end
