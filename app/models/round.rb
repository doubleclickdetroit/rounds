require Rails.root.join('lib','modules','common.rb')
require 'RMagick'

class Round < ActiveRecord::Base
  include Common::Scopes::Recent
  include Common::Scopes::Friends
  include Common::Scopes::BeforeAndAfter

  include Common::Associations::HasCreator

  has_many :slides, order: 'id DESC'
  has_many :invitations
  has_one  :round_lock
  has_many :watchings
  has_one  :dib

  validates_presence_of :slide_limit

  # todo lambda needed?
  after_save :check_for_round_completion

private
  # todo .env.test? bad?
  def check_for_round_completion
    return if Rails.env.test?

    build_completed_round_image()
  end
  
  def build_completed_round_image
    Resque.enqueue ImageBuilder, id if complete
  end
end
