require 'set'

class User < ActiveRecord::Base
  # todo left over from devise...
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :authorizations

  has_many :rounds
  has_many :slides
  has_many :comments
  has_many :watchings

  has_many :blacklist_entries


  def self.via_auth(auth_hash)
    auth = Authorization.find_or_initialize_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])

    if auth.new_record?
      user = User.create(:name => auth_hash['info']['name'])

      # todo this sucks, fix it
      auth.user = user
      auth.save
      user
    else
      user = auth.user
    end
  end

  def self.find_by_auth_hash(hash)
    auth = Authorization.find_by_provider_and_uid(hash['provider'], hash['uid'])
    auth.try(:user)
  end

  def friend_ids
    # todo
    []
  end

  def blocked_user_ids
    blacklist_entries.map {|ble| ble.blocked_user_id}
  end

end
