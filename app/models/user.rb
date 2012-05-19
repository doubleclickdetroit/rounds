require 'set'

class User < ActiveRecord::Base
  # todo left over from devise...
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  # todo do this better 
  # or DRY it out 
  has_many :rounds, :class_name => 'Round', :foreign_key => :user_id, :primary_key => :user_id
  has_many :slides, :class_name => 'Slide', :foreign_key => :user_id, :primary_key => :user_id
  has_many :comments, :class_name => 'Comment', :foreign_key => :user_id, :primary_key => :user_id
  has_many :watchings, :class_name => 'Watching', :foreign_key => :user_id, :primary_key => :user_id

  has_many :blacklist_entries, :foreign_key => :user_id, :primary_key => :user_id

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
