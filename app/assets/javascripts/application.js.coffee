define [], (require) ->

	StreamView = require "views/stream_view"

	initialize: ->
		@sentences = new StreamView stream_name: "sentences"
		@pictures  = new StreamView stream_name: "pictures"


	# StreamView (View)
		# StackView (View)
		# Slides (Collection)
			# Slide (Model)
			# SlideView (View)