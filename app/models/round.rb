class Round < ActiveRecord::Base
  has_many :slides, :order => 'position'

  belongs_to :created_by, :class_name => 'User', :foreign_key => :fid, :primary_key => :fid

  def creator
    created_by
  end
end
