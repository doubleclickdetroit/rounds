define [], (require) ->

	Backbone = require "backbone"

	mediator   = require "utils/mediator"
	PushState  = require 'utils/pushstate'

	class AppRouter extends Backbone.Router

		routes:
			""   : "render_home"
			"_=_": "redirect_home"

			"rounds/:id": "render_round"

		render_home: ->
			# Todo: include an arg from return of Parent ViewFactory to send along Sub ViewFactory
			mediator.publish 'navigateIndex'

		render_round: (round_id) ->
			# Todo: include an arg from return of Parent ViewFactory to send along Sub ViewFactory
			mediator.publish 'navigateRound', round_id

		redirect_home: ->
			@navigate '', true

		navigatePushState: (uri) ->
			@navigate uri, true

		initialize: ->
			Backbone.history.start
				pushState: true

			PushState.getInstance().subscribe @

	AppRouter