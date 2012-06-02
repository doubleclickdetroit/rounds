object @slide

attributes :type, :id

node(:content) {|slide| slide.content }

# todo maybe not perfomant
node(:created_at) {|record| record.created_at.to_s}

attributes :votes

node(:comment_count) {|slide| slide.comment_count }

child(:round) do 
  attributes :id
  node(:locked) {|round| !!round.round_lock}
end

# # todo
# # currently determined from 'slides/index'
# child(:user) { attributes :id, :name, :image_path } if @user_in_full
