require Rails.root.join('lib','modules','common.rb')

class Ballot < ActiveRecord::Base
  include Common::Associations::HasCreator
  belongs_to :slide

  before_validation :ensure_vote_value
  after_create :increment_slide_votes

private
  VOTE_RANGE = 1..5

  def ensure_vote_value
    VOTE_RANGE.include? vote
  end

  def increment_slide_votes
    slide.votes += vote
    slide.save
  end
end
