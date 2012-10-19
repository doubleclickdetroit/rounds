define [], (require) ->

	Singleton = require 'utils/singleton'
	facade    = require 'utils/facade'
	factory   = require 'factories/streams'


	# view store
	class Manager extends Singleton

		header  = null
		footer  = null
		content = null
		streams = null
		prev_stream_id = 'sentences'

		partials = ->
			if header.find('stream')? is false
				factory.request('header').addTo(header).open()

			if content.find('stream')? is false
				factory.request('content').addTo(content).open()

			if footer.find('stream')? is false
				factory.request('footer').addTo(footer).open()

		initialize: ->
			# find manager to manage stream regions
			header  = factory.request('manager').find 'header'
			footer  = factory.request('manager').find 'footer'
			content = factory.request('manager').find 'content'
			@

		open: (stream_id = prev_stream_id) ->
			# create header/footer if it doesn't already exist
			do partials

			# remember stream region
			streams ?= content.find 'stream'

			# create stream if it doesn't already exist
			if streams.find(stream_id)? is false
				factory.request(stream_id).addTo streams

			# open stream regions
			region.open('stream') for region in [header, content, footer]

			# close all other streams
			streams.all().except(stream_id).close()

			# open request stream
			streams.find(stream_id).open()

			# remember previous stream_id
			prev_stream_id = stream_id

		close: ->
			# close stream regions
			region.close('stream') for region in [header, content, footer]

		remove: ->
			# remove all stream regions
			region.remove('stream') for region in [header, content, footer]
			streams = null



	# Subscriptions
	facade.subscribe 'streams', 'navigate', (stream_id) ->
		# find manager to manage stream regions
		Manager.getInstance().open stream_id


	facade.subscribe 'router', 'navigate', (id, do_remove = false) ->
		# find manager to close/remove stream regions
		if id isnt 'streams'
			action = if do_remove then 'remove' else 'close'
			Manager.getInstance()[action]()


	@