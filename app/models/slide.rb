require Rails.root.join('lib','modules','common.rb')

class Slide < ActiveRecord::Base
  TYPES = [Sentence, Picture]

  include Common::Scopes::FriendsAndRecent
  include Common::Associations::HasCreator

  def self.of_type_and_before(type, time=nil)
    slides = self.of_type(type)
    slides = slides.before(time) if time
    slides.recent
  end

  after_create :add_position

  belongs_to :round

  has_many :comments

  def to_json
    to_hash.to_json
  end

  def to_hash
    attrs = %w[type id round_id created_at updated_at content]
    attrs.inject({}) {|h,k| h.merge({k => self.send(k)})}
  end

private
  def add_position
    self.position = round.slides.count - 1 if round
    self.save
  end
end
