require Rails.root.join('lib','modules','common.rb')

class Slide < ActiveRecord::Base
  include Common::Scopes::FriendsAndRecent
  include Common::Associations::HasCreator

  after_create  :add_position

  before_create :check_for_round_lock

  belongs_to :round

  has_many :comments

  def self.of_type_and_before(type, time=nil)
    time   = Time.parse time rescue nil
    slides = self.of_type(type)
    slides = slides.before(time) if time
    slides.recent
  end

  def to_json
    to_hash.to_json
  end

  def to_hash
    attrs = %w[type id round_id fid created_at updated_at content]
    attrs.inject({}) {|h,k| h.merge({k => self.send(k)})}
  end

private
  def add_position
    self.position = round.slides.count - 1 if round
    self.save
  end

  def check_for_round_lock
    !round.round_lock
  end
end
