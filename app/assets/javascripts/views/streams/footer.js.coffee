define [], (require) ->

	$ = require 'jquery'
	_ = require 'underscore'
	Backbone = require 'backbone'

	facade = require 'utils/facade'
	footer = require 'text!templates/streams/footer.html'


	class StreamNavView extends Backbone.View

		tagName : 'nav'
		template: _.template footer

		events:
			'click a' : 'handleStreamChange'

		handleStreamChange: (evt) ->
			evt.preventDefault()
			facade.publish 'streams', 'navigate', evt.target.id

		initialize: ->
			@$el.html @template


	StreamNavView