define [], (require) ->

	StreamView = require "views/stream_view"

	initialize: ->
		# eventually abstract this layer into a factory
		@sentences = new StreamView stream_name: "sentences"
		@pictures  = new StreamView stream_name: "pictures"


	# StreamView (View)
		# SlidesView (View)
		# Slides (Collection)
			# Slide (Model)
			# SlideView (View)