class BlacklistEntry < ActiveRecord::Base
  belongs_to :user, :foreign_key => :user_id, :primary_key => :user_id 
end
