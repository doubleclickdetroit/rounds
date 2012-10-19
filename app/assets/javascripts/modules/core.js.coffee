define ['jquery','utils/facade'], ($, facade) ->


	# subscriptions
	facade.subscribe 'resource', 'subscribe', (subscription, callback) ->
		console.log "subscribing to channel #{subscription.channel}"

		# subscribe to subsequent channel with callback
		PrivatePub.subscribe subscription.channel, callback

		# authenticate with PrivatePub/Faye server
		PrivatePub.sign subscription



	facade.subscribe 'friends', 'update', (friends) ->
		$.post '/api/users/me/friends', friends