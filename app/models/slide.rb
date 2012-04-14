class Slide < ActiveRecord::Base
  belongs_to :round

  has_many :comments

  def to_json
    to_hash.to_json
  end


private
  def to_hash
    attrs = %w[id round_id created_at updated_at content]
    attrs.inject({}) {|h,k| h.merge({k => self.send(k)})}
  end
end
