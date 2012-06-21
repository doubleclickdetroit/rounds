define [], ->

	does_exist = (channel, subscriber) ->
		typeof permissions[channel] isnt "undefined"

	permissions = {}

	set: (channel, subscriber, val) ->
		permissions[channel][subscriber] = val if does_exist channel, subscriber

	validate: (channel, subscriber) ->
		if does_exist( channel, subscriber ) then permissions[channel][subscriber] else true