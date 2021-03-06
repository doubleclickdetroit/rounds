require Rails.root.join('lib','modules','common.rb')

class RoundLock < ActiveRecord::Base
  # todo spec
  include Common::Associations::HasCreator

  after_create :notify_locked, :set_timeout_for_destroy
  before_destroy :notify_unlocked, :destroy_all_watchings

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

  def set_timeout_for_destroy
    return if Rails.env.test?
    Resque.enqueue_in(15.minutes, LockDissolver, id)
  end

  def notify_unlocked
    notify(false)
  end

  def destroy_all_watchings
    self.round.watchings.destroy_all
  end
end
