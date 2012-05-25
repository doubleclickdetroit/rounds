define [], (require) ->

	Backbone = require "backbone"

	class Slide extends Backbone.Model

		initialize: ->
			console.log "Slide", do @toJSON

	Slide