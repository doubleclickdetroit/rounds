object @round

attributes :id

node(:created_at) {|record| record.created_at.to_s}

# # todo
# # currently determined from 'rounds/index'
# child(:user) { attributes :id, :name, :image_path } if @user_in_full
