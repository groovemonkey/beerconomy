require 'digest/sha1'

class Beer < ActiveRecord::Base
  self.primary_key = "randID"
  before_create :calc_hash
  belongs_to :user

  private
  def calc_hash()
    to_hash = Time.now.to_s + ('a'..'z').to_a.shuffle[0,8].join
    self.randID = Digest::SHA1.hexdigest(to_hash)
  end

end
