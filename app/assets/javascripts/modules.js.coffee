define [], (require) ->

	$ = require "jquery"
	_ = require "underscore"

	facade = require "utils/facade"

	RoundView  = require "views/round_view"
	StreamView = require "views/stream_view"


	facade.subscribe 'emptyMainContent', ->
		do $('#main').empty


	facade.subscribe 'navigateIndex', ->
		facade.publish 'emptyMainContent'

		# eventually abstract this layer into a factory
		# have model for each stream
		# use singleton to prevent multiple instantiations
		sentences = new StreamView stream_name: "sentences"
		pictures  = new StreamView stream_name: "pictures"


	facade.subscribe 'navigateRound', (round_id) ->
		facade.publish 'emptyMainContent'

		# eventually abstract this layer into a factory
		new RoundView "round_id": round_id


	facade.subscribe 'renderRound', (context) ->
		# console.log 'renderRound', context


	facade.subscribe 'renderSlides', (context) ->
		# console.log 'renderSlides', context


	facade.subscribe 'renderSlide', (context, slide) ->
		# console.log 'renderSlide', context, slide