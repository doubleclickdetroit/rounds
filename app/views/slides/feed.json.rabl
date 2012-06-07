object @type => 'feed'

child @private_slides => 'private' do
  extends 'slides/private'
end

child @friends_slides => 'friends' do
  extends 'slides/friends'
end

child @community_slides => 'community' do
  extends 'slides/community'
end
