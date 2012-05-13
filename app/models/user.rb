require 'set'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # todo do this better 
  # or DRY it out 
  has_many :rounds, :class_name => 'Round', :foreign_key => :fid, :primary_key => :fid
  has_many :slides, :class_name => 'Slide', :foreign_key => :fid, :primary_key => :fid
  has_many :comments, :class_name => 'Comment', :foreign_key => :fid, :primary_key => :fid
  has_many :watchings, :class_name => 'Watching', :foreign_key => :fid, :primary_key => :fid

  has_many :blacklist_entries, :foreign_key => :user_fid, :primary_key => :fid

  def blocked_fids
    blacklist_entries.map {|ble| ble.blocked_fid}
  end

  def new_feed
    reject_blocked Round.recent
  end

  def friends_fids
    # todo
    []
  end

  def friends_feed
    filtered_friends_fids = remove_blocked_fids_from(friends_fids)
    Round.friends_recent(filtered_friends_fids)
  end


private
  def remove_blocked_fids_from(fids_arr)
    (Set.new(fids_arr) ^ blocked_fids).to_a
  end

  # todo maybe not the most effecient
  def reject_blocked(items)
    fids = blocked_fids
    items.reject do |item|
      fids.include? item.fid
    end
  end

end
