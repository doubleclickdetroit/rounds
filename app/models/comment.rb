require Rails.root.join('lib','modules','common.rb')

class Comment < ActiveRecord::Base
  include Common::Scopes::FriendsAndRecent
  include Common::Associations::HasCreator

  belongs_to :slide
  belongs_to :user
end
