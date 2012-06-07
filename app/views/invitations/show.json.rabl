object @invitation

attributes :id, :round_id, :private, :created_at

# todo maybe not perfomant
node(:created_at) {|record| record.created_at.to_s}

child(:user => :inviter) do
  attributes :id, :name, :image_path
end
