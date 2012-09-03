define [], (require) ->

	Backbone = require "backbone"

	facade    = require "utils/facade"
	PushState = require 'utils/pushstate'

	class AppRouter extends Backbone.Router

		routes:
			"_=_": "redirect_home"

			""           : "render_stream"

		render_stream: ->
			facade.publish 'streams', 'navigate'

		redirect_home: ->
			@navigate '', true

		navigatePushState: (uri) ->
			@navigate uri, true

		initialize: ->
			facade.publish 'window', 'init'

			Backbone.history.start
				pushState: true

			PushState.getInstance().subscribe @

	AppRouter
