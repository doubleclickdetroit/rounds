require Rails.root.join('lib','modules','common.rb')

class Invitation < ActiveRecord::Base
private
  class CreatorValidator < ActiveModel::Validator
    def validate(record)
      # only private round owner can invite users
      if record.private && (record.round.creator != record.creator)
        record.errors.add :base, 'Must be round creator to invite users to a private round' 
        raise ActiveRecord::RecordInvalid, record
      end
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
