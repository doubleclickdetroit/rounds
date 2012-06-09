object @type => 'feed'

node :private do
  partial 'slides/index', object: @private_slides
end

node :friends do
  partial 'slides/index', object: @friends_slides
end

node :community do
  partial 'slides/index', object: @community_slides
end
