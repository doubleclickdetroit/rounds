class Slide < ActiveRecord::Base
  belongs_to :round

  has_many :comments
end
