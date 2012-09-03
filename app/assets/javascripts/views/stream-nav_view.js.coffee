define [], (require) ->

	$ = require 'jquery'
	_ = require 'underscore'
	Backbone = require 'backbone'

	facade   = require 'utils/facade'
	nav_tmpl = require 'text!templates/stream_nav.html'


	class StreamNavView extends Backbone.View

		tagName : 'nav'
		template: _.template nav_tmpl

		events:
			'click a' : 'handleStreamChange'

		handleStreamChange: (evt) ->
			evt.preventDefault()
			facade.publish 'streams', 'navigate', evt.target.id

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


	StreamNavView