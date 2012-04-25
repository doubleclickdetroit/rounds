require 'set'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # todo DRY this out
  has_many :rounds, :class_name => 'Round', :foreign_key => :fid, :primary_key => :fid
  has_many :slides, :class_name => 'Slide', :foreign_key => :fid, :primary_key => :fid
  has_many :comments, :class_name => 'Comment', :foreign_key => :fid, :primary_key => :fid

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

  def recent_activity
    # todo move this to controller/view
    
    # todo scopes for models below
    @rounds   = Round.find   :all, :conditions => ['fid = ?', self.fid], :order => 'created_at desc', :limit => 10
    @slides   = Slide.find   :all, :conditions => ['fid = ?', self.fid], :order => 'created_at desc', :limit => 10
    @comments = Comment.find :all, :conditions => ['fid = ?', self.fid], :order => 'created_at desc', :limit => 10

    json = JSONBuilder::Compiler.generate do
      rounds @rounds do |round|
        id round.id
        created_at round.created_at
        updated_at round.updated_at
        fid round.fid
      end
      # todo differentiate Sentences/Pictures
      slides @slides do |slide|
        id slide.id
        type slide.type
        round_id slide.round_id
        created_at slide.created_at
        updated_at slide.updated_at
        fid slide.fid
        content slide.content
      end
      comments @comments do |comment|
        id comment.id
        type comment.type
        slide_id comment.slide_id
        created_at comment.created_at
        updated_at comment.updated_at
        fid comment.fid
        text comment.text
        inappropriate comment.inappropriate
      end
    end

    json
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
