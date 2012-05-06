require Rails.root.join('lib','modules','common.rb')

class RoundLock < ActiveRecord::Base
  # todo spec
  include Common::Associations::HasCreator
  belongs_to :round

  validates_presence_of :round_id
  validates_presence_of :fid
end
