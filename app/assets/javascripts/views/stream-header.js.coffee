define [], (require) ->

	$ = require 'jquery'
	_ = require 'underscore'
	Backbone = require 'backbone'

	facade = require 'utils/facade'
	header = require 'text!templates/stream_header.html'


	class StreamHeaderView extends Backbone.View

		tagName : 'nav'
		template: _.template header

		events:{}

		initialize: ->
			@$el.html @template

		onOpen: ->
			# console.log 'stream_nav_view onShow'
			@$el.show()
			@

		onClose: ->
			# console.log 'stream_nav_view onClose'
			@$el.hide()
			@


	StreamHeaderView