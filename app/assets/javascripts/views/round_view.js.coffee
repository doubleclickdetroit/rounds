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

			round_id = @options.round_id
			@collection = new Slides url: "/api/rounds/#{round_id}/slides"

			@collection.bind 'add',   @addOne
			@collection.bind 'reset', @addAll

		render: ->
			@$el.append round_tmpl
			mediator.publish 'round', 'render', @
			@

		watchRound: (evt) ->
			# create a Watching for this round

		addOne: (slide) ->
			view = new SlideView model: slide
			@$el.append view.render().el

		addAll: ->
			@collection.each @addOne


	RoundView
