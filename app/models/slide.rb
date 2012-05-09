require Rails.root.join('lib','modules','common.rb')

class Slide < ActiveRecord::Base
  include Common::Scopes::FriendsAndRecent
  include Common::Associations::HasCreator

  # todo refactor to common.rb?
  def self.feed(friends_fids)
    hash = {}

    # todo
    invitations = {}
    private_feed = {}

    friends   = friends_recent(friends_fids).map(&:to_hash)
    community = recent.all.map(&:to_hash)

    hash['invitations'] = invitations
    hash['private']     = private_feed
    hash['friends']     = friends
    hash['community']   = community
    
    hash
  end

  after_create  :add_position

  # before_create :before_create_processing

  belongs_to :round

  has_many :comments

  def self.of_type_and_before(type, time=nil)
    time   = Time.parse time rescue nil
    slides = self.of_type(type)
    slides = slides.before(time) if time
    slides.recent
  end

  # Slide.create_next(slide, :for => round, :with_lock => round_lock)
  def self.create_next(slide_hash)
    # REFACTOR THIS FFS
    # todo move this to .create + callbacks somehow
    
    # todo ||?
    slide_type = slide_hash.delete('type') || slide_hash.delete(:type)
    raise "#{slide_type.inspect} is not a valid slide type" unless [Sentence,Picture].map(&:to_s).include?(slide_type)

    klass = slide_type.constantize
    slide = klass.new(slide_hash)

    # todo?
    lock = slide.round.try(:round_lock)
    raise "Cannot create slide without round lock" unless lock.is_a? RoundLock

    lock_fid = lock.creator.fid
    slide_fid = slide.fid
    lock_belongs_to_user = lock_fid == slide_fid 
    raise "User does not have the round locked" unless lock_belongs_to_user

    last_type  = slide.round.slides.last.type
    raise "Cannot create a #{slide_type.downcase} after a #{slide_type.downcase}" if slide_type == last_type

    # todo
    saved = slide.save
    lock.destroy if saved
    saved
  end

  def comment_count
    comments.count
  end

  def to_hash
    attrs = %w[type id round_id fid created_at updated_at comment_count content]
    attrs.inject({}) {|h,k| h.merge({k => self.send(k)})}
  end

  def to_json
    to_hash.to_json
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
