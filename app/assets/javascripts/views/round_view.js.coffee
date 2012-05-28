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

		initialize: ->
			_.bindAll @, 'addOne', 'addAll', 'render'

			round_id = @options.round_id
			@collection = new Slides url: "/api/rounds/#{round_id}/slides"

			@collection.bind 'add',   @addOne
			@collection.bind 'reset', @addAll

			do @render
			do @collection.fetch

		render: ->
			$('#main').html @$el.append round_tmpl
			mediator.publish 'renderRound', @
			@

		addOne: (slide) ->
			view = new SlideView model: slide
			@$el.append view.render().el

		addAll: ->
			@collection.each @addOne
		

	RoundView