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
			mediator.publish 'streams', 'show'

		render_round: (round_id) ->

			##### START bchase #####
			##### START bchase #####

			subscribe_to_resource = (callback) ->
				console.log "in subscribe_to_resource"
				(data) ->
					subscription = data.subscription

					console.log "subscribing to channel #{subscription.channel}"

					# subscribe to subsequent channel with callback
					PrivatePub.subscribe subscription.channel, (data, channel) ->
						callback(data)

					# authenticate with PrivatePub/Faye server
					PrivatePub.sign subscription

			set_lock = (data) ->
				console.log "in lock callback", data
				if data.locked
					$('h2').text('View Round LOCKED')
				else
					$('h2').text('View Round')

			watch_round = (data) ->
				console.log "in watch callback"
				alert data.message

			# subscribe to round_lock
			$.ajax("/api/rounds/#{round_id}/lock").done subscribe_to_resource(set_lock)

			button = $ '<button>', text: 'Watch Round'
			$('header').prepend	button

			button.click ->
				# create a Watching for this round
				$.post "/api/rounds/#{round_id}/watch", subscribe_to_resource(watch_round)

			##### END bchase #####
			##### END bchase #####


			# Todo: include an arg from return of Parent ViewFactory to send along Sub ViewFactory
			mediator.publish 'round', 'show', round_id

		redirect_home: ->
			@navigate '', true

		navigatePushState: (uri) ->
			@navigate uri, true

		initialize: ->
			Backbone.history.start
				pushState: true

			PushState.getInstance().subscribe @

	AppRouter
