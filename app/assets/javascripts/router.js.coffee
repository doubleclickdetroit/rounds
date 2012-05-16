define ['backbone'], (Backbone) ->

	class AppRouter extends Backbone.Router

		routes:
			"": "home_actions"

		home_actions: ->
			console.log 'home_actions invoked!'

	AppRouter