class BlacklistEntry < ActiveRecord::Base
  belongs_to :user, :foreign_key => :user_fid, :primary_key => :fid 
end
