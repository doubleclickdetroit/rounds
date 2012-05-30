require Rails.root.join('lib','modules','common.rb')

class RoundLock < ActiveRecord::Base
  # todo spec
  include Common::Associations::HasCreator

  after_create :notify_locked
  before_destroy :notify_unlocked, :before_destroy_processing

  belongs_to :round

  validates_presence_of :round_id
  validates_presence_of :user_id

private
  def notify(locked)
    PrivatePub.publish_to "/api/rounds/#{round_id}/lock", locked: locked
  end

  def notify_locked
    notify(true)
  end

  def notify_unlocked
    notify(false)
  end

  def before_destroy_processing
    self.round.watchings.destroy_all
  end
end
