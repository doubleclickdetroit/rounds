define [], (require) ->

	_ = require 'underscore'
	Backbone = require 'backbone'

	facade = require 'utils/facade'
	header_tmpl = require 'text!templates/streams/header.html'


	class StreamHeaderView extends Backbone.View
		tagName : 'nav'

		initialize: ->
			@$el.html _.template header_tmpl


	StreamHeaderView