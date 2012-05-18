class BlacklistEntry < ActiveRecord::Base
  belongs_to :user, :foreign_key => :fid, :primary_key => :fid 
end
