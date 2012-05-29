define [], (require) ->

	$ = require "jquery"
	_ = require "underscore"

	facade = require "utils/facade"

	RoundView  = require "views/round_view"
	StreamView = require "views/stream_view"


	facade.subscribe 'emptyMainContent', ->
		do $('#main').empty


	facade.subscribe 'navigateIndex', (->

		streams      = {}
		has_rendered = false

		renderDelegation = ->
			facade.publish 'emptyMainContent'
			if has_rendered is on then do reRender else do initRender
			@

		initRender = ->
			has_rendered = true

			# have model for each stream
			# use singleton to prevent multiple instantiations
			streams.sentences = new StreamView stream_name: "sentences"
			streams.pictures  = new StreamView stream_name: "pictures"

		reRender = ->
			do streams.sentences.render
			do streams.pictures.render

		# eventually abstract this layer into a factory
		renderDelegation
	)()


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