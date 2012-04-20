class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :rounds, :class_name => 'Round', :foreign_key => :fid, :primary_key => :fid
  has_many :slides, :class_name => 'Slide', :foreign_key => :fid, :primary_key => :fid
  has_many :comments, :class_name => 'Comment', :foreign_key => :fid, :primary_key => :fid

  has_many :blacklist_entries, :foreign_key => :user_fid, :primary_key => :fid

  def blocked_fids
    blacklist_entries.map {|ble| ble.blocked_fid}
  end

  def new_feed
    Round.recent
  end

  def friends_fids
    # todo
    []
  end

  def friends_feed
    Round.friends_recent(friends_fids)
  end

end
