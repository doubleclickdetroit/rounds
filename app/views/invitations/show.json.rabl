object @invitation

attributes :id, :round_id, :private, :created_at

# todo maybe not perfomant
node(:created_at) {|record| record.created_at.to_s}

node(:last_slide) {|record| partial 'slides/show', object: Slide.where(round_id: record.round_id).last}

child(:user => :inviter) do
  attributes :id, :name, :image_path
end
