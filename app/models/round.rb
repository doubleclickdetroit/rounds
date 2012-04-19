class Round < ActiveRecord::Base
  has_many :slides, :order => 'position'

  belongs_to :created_by, :class_name => 'User', :foreign_key => :fid, :primary_key => :fid

  scope :recent, :order => 'created_at desc', :limit => 10
  scope :friends, lambda {|fid_arr|
    cond_str = fid_arr.inject('') do |str,fid|
      str << " OR " unless str.empty?
      str << "fid = #{fid}"
    end

    where(cond_str)
  }

  def creator
    created_by
  end

  def self.friends_recent(fid_arr)
    friends(fid_arr).recent
  end

end
