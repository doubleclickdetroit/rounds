define [], (require) ->

	$ = require "jquery"
	_ = require "underscore"

	SlidesView = require "views/slides_view"
	Slides     = require "collections/slides"

	class StreamView extends Backbone.View

		initialize: (options)->
			_.bindAll @, "create"

			@stream_name = options.stream_name
			do @bootstrap

		create: (stack_name, stack) ->
			slides = new Slides
				rootNode: stack_name
				url     : "/api/#{@stream_name}/#{stack_name}"

			# seed initial data
			slides.reset stack

		bootstrap: () ->
			self = @
			$.getJSON("/api/#{@stream_name}").done (slides) ->
				$.each slides, self.create
			@

	StreamView