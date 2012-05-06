class Watching < ActiveRecord::Base
  belongs_to :slide

  # todo
  # validates_presence_of :slide_id, :fid
end
