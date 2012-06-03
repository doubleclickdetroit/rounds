define [], (require) ->

	Backbone = require "backbone"

	mediator    = require "utils/mediator"
	SlideView   = require "./slide_view"
	slides_tmpl = require "text!templates/slides.html"

	SlidesView = Backbone.View.extend

		tagName  : "section"
		className: "ui-stack"

		# cache template fn for single item
		template: _.template slides_tmpl

		initialize: ->
			_.bindAll @, 'addOne', 'addAll', 'render'

			@collection.bind 'add',    @addOne
			@collection.bind 'reset',  @addAll
			@collection.bind 'remove', @addAll

		render: ->
			@$el.html @template( @options )
			mediator.publish 'slides', 'render', @
			@

		addOne: (slide) ->
			view = new SlideView model: slide
			@$el.append view.render().el

		addAll: ->
			@collection.each @addOne

	SlidesView