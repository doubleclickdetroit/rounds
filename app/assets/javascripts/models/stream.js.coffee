define [], (require) ->

	$ = require 'jquery'
	_ = require 'underscore'
	Backbone = require 'backbone'


	class Stream extends Backbone.Model

		urlRoot: "/api"

		initialize: (options) ->
			@id         = options.id
			@collection = options.collection
			@defaults   = selected: null
			@bootstrap()


		bootstrap: ->
			$.getJSON @url(), (json) =>

				# setter for stack names
				@set 'stacks', _.keys(json)

				# create stack collections
				$.each json, @create

				# default selected value to first stack
				@request @get('stacks')[0]


		create: (id, slides) =>
			# create collection
			stack = new @collection slides, silent:true
			stack.url = "#{@url()}/#{id}"

			# setter for collection
			@set id, stack


		request: (id) ->
			stack = @get id
			@set 'selected', stack
			@


	Stream