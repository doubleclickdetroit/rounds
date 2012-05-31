object @type => 'feed'

node(:private) { [] }

child @friends_slides => 'friends' do
  extends 'slides/friends'
end

child @community_slides => 'community' do
  extends 'slides/community'
end
