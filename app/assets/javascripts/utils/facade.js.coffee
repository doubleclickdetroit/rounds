define ['./mediator'], (mediator) ->

	facade = facade or {}

	facade.subscribe = (channel, callback) ->
		mediator.subscribe channel, callback

	facade.publish = (channel) ->
		mediator.publish channel

	facade