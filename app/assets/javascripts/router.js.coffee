define [], (require) ->

	Backbone = require 'backbone'

	facade    = require 'utils/facade'
	PushState = require 'utils/pushstate'

	class AppRouter extends Backbone.Router

		routes:
			'_=_' : 'redirect_home'
			''    : 'render_stream'

			'rounds/:id' : 'render_round'


		navigatePushState: (uri) ->
			@navigate uri, true


		redirect_home: ->
			@navigate '', true


		render_stream: ->
			facade.publish 'router', 'navigate', 'streams'
			facade.publish 'streams', 'navigate'


		render_round: (id) ->
			facade.publish 'router', 'navigate', 'rounds'
			facade.publish 'rounds', 'navigate', id


		initialize: ->
			facade.publish 'window', 'init'

			Backbone.history.start
				pushState: true

			PushState.getInstance().subscribe @


	AppRouter
