object @type => 'feed'

# todo invitations and private rounds

# todo child root broken pending https://github.com/nesquena/rabl/issues/240 ?
child @community_slides => 'community' do
  extends 'slides/community', :object_root => @type.downcase
end
child @friends_slides => 'friends' do
  extends 'slides/friends', :object_root => @type.downcase
end
# todo child root broken pending https://github.com/nesquena/rabl/issues/240 ?
