define [], (require) ->

	$ = require 'jquery'
	_ = require 'underscore'
	Backbone = require 'backbone'


	class StreamView extends Backbone.View

		tagName: 'section'

		render: ->
			console.log 'stream_view # render'
			@

		onOpen: ->
			console.log 'stream_view # onShow'
			@$el.show()
			@

		onClose: ->
			console.log 'stream_view # onClose'
			@$el.hide()
			@


	StreamView