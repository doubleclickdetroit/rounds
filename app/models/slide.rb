require Rails.root.join('lib','modules','common.rb')

class Slide < ActiveRecord::Base
  include Common::Scopes::FriendsAndRecent
  include Common::Associations::HasCreator

  after_create  :add_position

  before_create :before_create_processing

  belongs_to :round

  has_many :comments
  has_many :watchings

  def self.of_type_and_before(type, time=nil)
    time   = Time.parse time rescue nil
    slides = self.of_type(type)
    slides = slides.before(time) if time
    slides.recent
  end

  # todo move this to .create + callbacks
  # Slide.create_next(slide, :for => round, :with_lock => round_lock)
  def self.create_next(*args)
    slide = args.first
    slide_type = slide.delete('type')

    args  = args.extract_options!
    round = args.fetch :for
    last_type  = round.slides.last.type

    # raise "Cannot create a #{last_type} after a #{last_type}" if last_type == slide_type

    lock  = args.fetch :with_lock

    klass = slide_type.constantize
    klass.create(slide) 
  end

  def to_json
    to_hash.to_json
  end

  def to_hash
    attrs = %w[type id round_id fid created_at updated_at content]
    attrs.inject({}) {|h,k| h.merge({k => self.send(k)})}
  end

private
  # todo maybe remove this...
  def add_position
    self.position = round.slides.count - 1 if round
    self.save
  end

  def check_for_round_lock
    !round.round_lock
  end

  def before_create_processing
    check_for_round_lock

  end
end
