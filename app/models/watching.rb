class Watching < ActiveRecord::Base
  include Common::Scopes::Recent
  include Common::Scopes::Friends
  include Common::Scopes::BeforeAndAfter

  include Common::Associations::HasCreator


  belongs_to :round

  # todo
  # validates_presence_of :slide_id, :user_id

  before_destroy :send_push_notification

protected
  def message
    "Round #{round_id} is unlocked!"
  end

  def channel
    "/api/rounds/#{round_id}/watch"
  end

  def send_push_notification
    message = self.send :message # || "Round #{round_id} is unlocked!"
    channel = self.send :channel # || "/api/rounds/#{round_id}/watch"
    PrivatePub.publish_to channel, message: message
  end
end
