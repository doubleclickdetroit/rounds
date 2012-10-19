define [], (require) ->

	_ = require 'underscore'
	Backbone = require 'backbone'

	content_tmpl = require 'text!templates/streams/content.html'


	class StreamContentView extends Backbone.View

		tagName : 'div'
		id      : 'streams'

		events:
			'click .modal a' : 'handleModalAction'

		handleModalAction: (evt) ->
			evt.preventDefault()
			console.log 'handleModalAction', evt.currentTarget

		initialize: ->
			@$el.html _.template content_tmpl


	StreamContentView