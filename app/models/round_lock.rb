require Rails.root.join('lib','modules','common.rb')

class RoundLock < ActiveRecord::Base
  # todo spec
  include Common::Associations::HasCreator

  before_destroy :before_destroy_processing

  belongs_to :round
  has_many   :watchings, :class_name => 'Watching', :primary_key => :round_id, :foreign_key => :round_id

  validates_presence_of :round_id
  validates_presence_of :fid

private
  def before_destroy_processing
    self.watchings.destroy_all
  end
end
