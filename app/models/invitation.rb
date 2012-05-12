require Rails.root.join('lib','modules','common.rb')

class Invitation < ActiveRecord::Base
  include Common::Associations::HasCreator

  belongs_to :round
end
