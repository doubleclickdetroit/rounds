class Watching < ActiveRecord::Base
  belongs_to :round_lock, :class_name => 'RoundLock', :primary_key => :round_id, :foreign_key => :round_id

  # todo
  # validates_presence_of :slide_id, :fid

  before_destroy :send_push_notification

private
  def send_push_notification
    # todo
  end
end
