define [], (require) ->

	$ = require "jquery"
	_ = require "underscore"

	facade = require "utils/facade"

	RoundView  = require "views/round_view"
	StreamView = require "views/stream_view"


	clear_main_content = ->
		do $('#main').empty


	facade.subscribe 'ajax', 'complete', (xhr) ->
		do window.location.reload if xhr.status is 601
		@


	facade.subscribe 'streams', 'show', (->
		streams      = {}
		has_rendered = false

		renderDelegation = ->
			do clear_main_content
			if has_rendered is on then do reRender else do initRender
			@

		initRender = ->
			has_rendered = true

			# eventually abstract this layer into a factory
			# have model for each stream
			# use singleton to prevent multiple instantiations
			streams.sentences = new StreamView stream_name: "sentences"
			streams.pictures  = new StreamView stream_name: "pictures"

		reRender = ->
			do streams.sentences.render
			do streams.pictures.render

		renderDelegation
	)()


	facade.subscribe 'round', 'show', (round_id) ->
		# eventually abstract this layer into a factory
		round = new RoundView "round_id": round_id
		do round.render
		@


	facade.subscribe 'round', 'render', (context) ->
		# console.log 'renderRound', context
		clear_main_content().append context.el
		do context.collection.fetch
		@


	facade.subscribe 'slides', 'render', (context) ->
		# console.log 'renderSlides', context
		@


	facade.subscribe 'slide', 'render', (context, slide) ->
		# console.log 'renderSlide', context, slide
		@