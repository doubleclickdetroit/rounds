define [], (require) ->

	Backbone = require "backbone"

	mediator  = require "utils/mediator"
	PushState = require 'utils/pushstate'

	class AppRouter extends Backbone.Router

		routes:
			"_=_": "redirect_home"

			""           : "render_stream"
			"streams/:id": "render_stream"

			"rounds/:id": "render_round"

		render_stream: (stream_id = 'sentences') ->
			mediator.publish 'streams', 'navigate', stream_id

		render_round: (round_id) ->

		redirect_home: ->
			@navigate '', true

		navigatePushState: (uri) ->
			@navigate uri, true

		initialize: ->
			mediator.publish 'window', 'init'

			Backbone.history.start
				pushState: true

			PushState.getInstance().subscribe @

	AppRouter
