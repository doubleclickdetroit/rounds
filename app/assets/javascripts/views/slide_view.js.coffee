define [], (require) ->

	_ = require "underscore"
	Backbone = require "backbone"

	mediator   = require "utils/mediator"
	slide_tmpl = require "text!templates/slide.html"

	class SlideView extends Backbone.View

		tagName  : "li"
		className: "ui-slide"

		# cache template fn for single item
		template: _.template slide_tmpl

		initialize: ->
			_.bindAll @, 'render'
			@model.bind 'change', @render
			do @render

		render: ->
			@$el.html @template( do @model.toJSON )
			mediator.publish 'renderSlide', @, @model.toJSON()
			@

	SlideView