define [], (require) ->

	_ = require 'underscore'
	Backbone = require 'backbone'


	class Rounds extends Backbone.Collection

		initialize: (options) ->
			_.bindAll @, 'fetch'
			@url = "/api/rounds/#{options.id}/slides"

	Rounds