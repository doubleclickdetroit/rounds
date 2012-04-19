class Slide < ActiveRecord::Base
  after_create :add_position

  belongs_to :round

  has_many :comments

  scope :recent, :order => 'created_at desc', :limit => 10

  belongs_to :created_by, :class_name => 'User', :foreign_key => :fid, :primary_key => :fid

  def creator
    created_by
  end

  def to_json
    to_hash.to_json
  end

  def to_hash
    attrs = %w[type id round_id created_at updated_at content]
    attrs.inject({}) {|h,k| h.merge({k => self.send(k)})}
  end


private
  def add_position
    self.position = round.slides.count - 1 if round
    self.save
  end
end
