define [], (require) ->

	$ = require "jquery"
	_ = require "underscore"
	Backbone = require "backbone"

	mediator   = require "utils/mediator"
	round_tmpl = require "text!templates/round.html"
	Slides     = require "collections/slides"
	SlideView  = require "./slide_view"

	class RoundView extends Backbone.View

		tagName  : "section"
		className: "ui-round"

		# cache template fn for single item
		template: _.template round_tmpl

		events: "click button" : "watchRound"

		initialize: ->
			_.bindAll @, 'addOne', 'addAll', 'render'

			@round_id = @options.round_id
			@collection = new Slides url: "/api/rounds/#{@round_id}/slides"

			@collection.bind 'add',   @addOne
			@collection.bind 'reset', @addAll

		render: ->
			@$el.append round_tmpl
			mediator.publish 'round', 'render', @
			do @setLock
			@

		watchRound: ->
			# create a Watching for this round
			$.post( "/api/rounds/#{@round_id}/watch" ).done (resp) ->
				mediator.publish 'resource', 'subscribe', resp, (data) ->
					alert data.message

		setLock: ->
			$h2  = $('h2', @$el)
			text = $h2.text().replace "LOCKED", ""

			# I think this will go in the model and we'll hit a getter from the model?
			$.ajax( "/api/rounds/#{@round_id}/lock" ).done (resp) ->
				mediator.publish 'resource', 'subscribe', resp, (data) ->
					$h2.text "#{text} #{data.locked and 'LOCKED' or ''}"

		addOne: (slide) ->
			view = new SlideView model: slide
			@$el.append view.render().el

		addAll: ->
			@collection.each @addOne


	RoundView
