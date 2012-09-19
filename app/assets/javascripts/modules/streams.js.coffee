define [], (require) ->

	Singleton = require 'utils/singleton'
	facade    = require 'utils/facade'
	factory   = require 'factories/streams'


	# view store
	class Manager extends Singleton

		header  = null
		footer  = null
		content = null

		partials = ->
			if header.find('stream')? is false
				factory.request('header').addTo(header).open()

			if footer.find('stream')? is false
				factory.request('footer').addTo(footer).open()

		initialize: ->
			# find manager to manage stream regions
			header  = factory.request('manager').find 'header'
			footer  = factory.request('manager').find 'footer'
			content = factory.request('manager').find 'content'
			@

		open: (stream_id) ->
			# create header/footer if it doesn't already exist
			do partials

			# create stream if it doesn't already exist
			if content.find(stream_id)? is false
				factory.request(stream_id).addTo content

			# close all other streams
			content.all().except(stream_id).close()

			# open request stream
			content.find(stream_id).open()

		close: ->
			# close regions



	# helper method
	subscribe = (id, fn) ->
		facade.subscribe 'streams', id, fn


	# Subscriptions
	subscribe 'navigate', (stream_id = 'sentences') ->

		# find manager to manage stream regions
		Manager.getInstance().open stream_id


	subscribe 'close', ->

		Manager.getInstance().close


	@