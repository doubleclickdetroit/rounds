require Rails.root.join('lib/modules/common.rb')

class Slide < ActiveRecord::Base
  include Common::Scopes::Recent
  include Common::Scopes::Friends
  include Common::Scopes::BeforeAndAfter

  include Common::Associations::HasCreator


  belongs_to :round

  has_many :comments
  has_many :ballots


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

  def self.build_json_for_feed(community, friends, priv=[])
    puts community.inspect
    puts friends.inspect
    {
      'community' => community.map(&:to_hash),
      'friends'   => friends.map(&:to_hash)
    }
  end

  ATTRS = %w(type id round_id votes created_at)
  def to_hash
    hash  = self.attributes.select { |key,v| ATTRS.include? key }

    hash['created_at']       = hash['created_at'] # todo transform this
    hash['content']          = self.content
    hash['comment_count']    = self.comments.count
    hash['round_locked']     = !!self.round.round_lock
    hash['user']             = self.user.attributes.select {|k,v| %w(id name image_path).include? k}

    hash
  end

end
