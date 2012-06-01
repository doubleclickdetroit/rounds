object @slide

attributes :type, :id, :round_id, :votes # , :created_at

# todo maybe not perfomant
node(:created_at) {|record| record.created_at.to_s}

node(:content) {|slide| slide.content }
node(:comment_count) {|slide| slide.comment_count }
node(:round_lock) {|slide| !!slide.round.round_lock }

# # todo
# # currently determined from 'slides/index'
# child(:user) { attributes :id, :name, :image_path } if @user_in_full
