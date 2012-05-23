require Rails.root.join('lib/modules/common.rb')

class Slide < ActiveRecord::Base
  include Common::Scopes::Recent
  include Common::Scopes::Friends
  include Common::Scopes::BeforeAndAfter

  include Common::Associations::HasCreator


  belongs_to :round

  has_many :comments
  has_many :ballots


  # the firehose, but with :limit => 8,
  # sorted, with users blocked as needed, 
  # and with before/after taken care of.
  def self.community_feed(*args)
    # todo make this more readable?
    user = args.shift
    args = args.extract_options!

    if val = args[:before] 
      @offset = [:before, val]
    elsif val = args[:after]
      @offset = [:after, val]
    end

    slides = (@offset ? self.send(*@offset) : self).recent(user)
  end

  # todo ensure ActiveRelation handles this well (performance)
  def self.feed_by_user_and_time(user, params)
    # the firehose, but already with :limit => 8,
    # sorted, with users blocked as needed, and
    # with before/after taken care of.
    #
    # a .where is chained to only return records
    # created by the User record passed in.
    community_feed(params[:user_id]).where(:user_id => user.id)
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

    lock_belongs_to_user = lock.creator.id == slide.user_id 
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

end
