define [], (require) ->

	_ = require "underscore"
	Backbone = require "backbone"

	slide_tmpl = require "text!templates/rounds/slide.html"

	class SlideView extends Backbone.View

		tagName  : "li"

		# cache template fn for single item
		template: _.template slide_tmpl

		initialize: ->
			_.bindAll @, 'render'
			@model.bind 'change', @render

		render: ->
			@$el.html @template( @model.toJSON() )
			@

	SlideView