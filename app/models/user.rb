class User < ActiveRecord::Base
  has_many :beers, dependent: :destroy

  def self.from_omniauth(auth)
    find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end

  def brokenPush(arrayname, value)
    #hack = "self.update(#{arrayname}: [(self.#{arrayname} << '#{value}')].flatten)"
    #puts hack
    #exec("#{hack}")
  end

  def wtf(val)
    self.update(beersOffered: [(self.beersOffered << val)].flatten)
  end

  
end
