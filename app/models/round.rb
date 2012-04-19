require Rails.root.join('lib','modules','common.rb')

class Round < ActiveRecord::Base
  include Common::Scopes::FriendsAndRecent
  include Common::Associations::HasCreator

  has_many :slides, :order => 'position'

end
