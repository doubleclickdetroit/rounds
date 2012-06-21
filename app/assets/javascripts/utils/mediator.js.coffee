define [], (require) ->

	channels = {}

	subscribe: (channel, subscription, callback) ->
		channels[channel] ?= {}
		channels[channel][subscription] ?= []
		channels[channel][subscription].push callback
		@

	publish: (channel, subscription, args...) ->
		return false if channels[channel] is undefined or channels[channel][subscription] is undefined
		callback args... for callback in channels[channel][subscription]
		@