define [], ->

	does_exist = (channel, subscriber) ->
		typeof permissions[channel] isnt "undefined"

	permissions =
		ajax:
			complete: true

		resource:
			subscribe: true

		streams:
			show: true

		round:
			show  : true
			render: true

		slides:
			render: true

		slide:
			render: true

	set: (channel, subscriber, val) ->
		permissions[channel][subscriber] = val if does_exist channel, subscriber

	validate: (channel, subscriber) ->
		if does_exist( channel, subscriber ) then permissions[channel][subscriber] else false