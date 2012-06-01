define [], (require) ->

	_        = require "underscore"
	Backbone = require "backbone"

	Slide = require "models/slide"

	class Slides extends Backbone.Collection

		model: Slide

		initialize: (options) ->
			_.bindAll @, "fetch"
			@url      = options.url
			@rootNode = options.rootNode or null

		parse: (data) ->
			data[@rootNode] or data

	Slides