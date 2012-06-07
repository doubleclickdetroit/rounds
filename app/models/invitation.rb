require Rails.root.join('lib','modules','common.rb')

class Invitation < ActiveRecord::Base
  include Common::Scopes::Recent
  include Common::Scopes::Friends
  include Common::Scopes::BeforeAndAfter

  include Common::Associations::HasCreator

  belongs_to :round

  scope :private, where(:private => true)

  after_create :set_privacy

private
  def set_privacy
    self.private = !!round.private
    self.save
  end
end
