define [], (require) ->

	Backbone = require "backbone"

	SlidesView = Backbone.View.extend

		initialize: ->
			console.log "SlidesView", @collection

	SlidesView