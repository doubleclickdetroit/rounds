require Rails.root.join('lib','modules','common.rb')

class Ballot < ActiveRecord::Base
  include Common::Associations::HasCreator
  belongs_to :slide

  validates :vote, :inclusion => { :in => 1..5, :message => '%{value} is not a valid vote'}
  validates_presence_of :user_id
  validates :user_id, :presence => true, :uniqueness => true

  after_create :increment_slide_votes

private
  def increment_slide_votes
    slide.votes += vote
    slide.save
  end
end
