require Rails.root.join('lib','modules','common.rb')

class Invitation < ActiveRecord::Base
private
  class CreatorValidator < ActiveModel::Validator
    def validate(inv)
      if inv.round.private 
        raise ActiveRecord::RecordInvalid, 'Must be round creator to invite users to a private round' if inv.round.creator != inv.creator
      end

      true
    end
  end

public
  include Common::Scopes::Recent
  include Common::Scopes::Friends
  include Common::Scopes::BeforeAndAfter

  include Common::Associations::HasCreator

  validates_with CreatorValidator 

  belongs_to :round

  scope :private, where(:private => true)

  after_create :set_privacy

private
  def set_privacy
    self.private = !!round.private
    self.save
  end
end
