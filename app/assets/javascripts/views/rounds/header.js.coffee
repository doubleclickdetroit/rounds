define [], (require) ->

	_ = require 'underscore'
	Backbone = require 'backbone'

	facade = require 'utils/facade'
	header_tmpl = require 'text!templates/rounds/header.html'

	class RoundHeaderView extends Backbone.View
		tagName : 'nav'

		initialize: ->
			@$el.html _.template header_tmpl


	RoundHeaderView