require Rails.root.join('lib','modules','common.rb')

class Round < ActiveRecord::Base
  include Common::Scopes::Recent
  include Common::Scopes::Friends
  include Common::Scopes::BeforeAndAfter

  include Common::Associations::HasCreator

  has_many :slides, :order => 'id DESC'
  has_many :invitations
  has_one  :round_lock
  has_many :watchings
  has_one  :dib

  validates_presence_of :slide_limit
end
