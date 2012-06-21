define [], (require) ->

	$ = require 'jquery'
	_ = require 'underscore'
	Backbone = require 'backbone'


	class Stream extends Backbone.Model

		urlRoot: "/api"

		initialize: (options) ->
			console.log 'StreamModel', @, @options

	Stream