define ['./mediator', 'permissions'], (mediator, permissions) ->

	facade = facade or {}

	facade.subscribe = (channel, subscriber, callback) ->
		mediator.subscribe channel, subscriber, callback if permissions.validate( channel, subscriber )

	facade.publish = (channel, subscriber, args...) ->
		mediator.publish channel, subscriber, args...

	facade