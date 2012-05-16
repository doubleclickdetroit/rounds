define ['router'], (Router) ->

	name: "Rounds Mobile Game"
	version: "0.1.dev"

	initialize: ->
		new Router()
		Backbone.history.start()