class Round < ActiveRecord::Base
  has_many :slides, :order => 'position'
end
