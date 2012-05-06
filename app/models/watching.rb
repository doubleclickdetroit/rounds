class Watching < ActiveRecord::Base
  belongs_to :slide

  # todo
  # validates_presence_of :slide_id, :fid

  before_destroy :send_push_notification

private
  def send_push_notification
    # todo
  end
end
