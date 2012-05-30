require Rails.root.join('lib','modules','common.rb')

class RoundLock < ActiveRecord::Base
  # todo spec
  include Common::Associations::HasCreator

  before_destroy :before_destroy_processing

  belongs_to :round

  validates_presence_of :round_id
  validates_presence_of :user_id

private
  def before_destroy_processing
    self.round.watchings.destroy_all
  end
end
