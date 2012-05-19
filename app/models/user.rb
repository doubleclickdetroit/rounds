require 'set'

class User < ActiveRecord::Base
  # todo left over from devise...
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :rounds
  has_many :slides
  has_many :comments
  has_many :watchings

  has_many :blacklist_entries

  def blocked_user_ids
    blacklist_entries.map {|ble| ble.blocked_user_id}
  end

  def new_feed
    reject_blocked Round.recent
  end

  def friends_user_ids
    # todo
    []
  end

  def friends_feed
    filtered_friends_user_ids = remove_blocked_user_ids_from(friends_user_ids)
    Round.friends_recent(filtered_friends_user_ids)
  end


private
  def remove_blocked_user_ids_from(user_ids_arr)
    (Set.new(user_ids_arr) ^ blocked_user_ids).to_a
  end

  # todo maybe not the most effecient
  def reject_blocked(items)
    user_ids = blocked_user_ids
    items.reject do |item|
      user_ids.include? item.user_id
    end
  end

end
