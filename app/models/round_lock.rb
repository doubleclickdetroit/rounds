class RoundLock < ActiveRecord::Base
  belongs_to :round

  validates_presence_of :round_id
  validates_presence_of :user_fid
end
