define [], (require) ->

	$ = require "jquery"
	_ = require "underscore"

	mediator    = require "utils/mediator"
	Slides      = require "collections/slides"
	SlidesView  = require "views/slides_view"

	class StreamView extends Backbone.View

		tagName  : "section"
		className: "ui-stream"

		initialize: ->
			_.bindAll @, "create"
			do @render
			do @bootstrap

		render: ->
			mediator.publish 'streams', 'render', @

		bootstrap: ->
			self = @
			$.getJSON("/api/#{@options.stream_name}").done (slides) ->
				$.each slides, self.create
			@

		create: (stack_name, stack) ->
			slides = new Slides
				rootNode: stack_name
				url     : "/api/#{@options.stream_name}/#{stack_name}"

			view = new SlidesView
				title     : stack_name
				collection: slides

			@$el.append view.render().el

			# seed initial data
			slides.reset stack

	StreamView