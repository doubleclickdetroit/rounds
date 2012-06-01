require Rails.root.join('lib','modules','common.rb')

class Ballot < ActiveRecord::Base
  include Common::Scopes::Recent
  include Common::Scopes::Friends
  include Common::Scopes::BeforeAndAfter

  include Common::Associations::HasCreator


  belongs_to :slide

  validates :vote, :inclusion => { :in => 1..5, :message => '%{value} is not a valid vote'}
  validates_presence_of :user_id
  validates_uniqueness_of :user_id, :scope => :slide_id

  after_create :increment_slide_votes

private
  def increment_slide_votes
    slide.votes += vote
    slide.save
  end
end
