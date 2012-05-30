class Watching < ActiveRecord::Base
  include Common::Scopes::Recent
  include Common::Scopes::Friends
  include Common::Scopes::BeforeAndAfter

  include Common::Associations::HasCreator


  belongs_to :round

  # todo
  # validates_presence_of :slide_id, :user_id

  before_destroy :send_push_notification

private
  def send_push_notification
    # todo
  end
end
