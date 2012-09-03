define [], (require) ->

	facade  = require 'utils/facade'
	factory = require 'factories/streams'


	# helper method
	subscribe = (id, fn) ->
		facade.subscribe 'streams', id, fn


	# Subscriptions
	subscribe 'navigate', (stream_id = 'sentences') ->

		# get maanger to manage stream regions
		footer  = factory.request('manager').get 'footer'
		content = factory.request('manager').get 'content'

		# create nav and add to manager if it doesn't already exist
		if footer.find('nav')? is false
			factory.request('nav').addTo(footer).open()

		# creaete stream and add to manager if it doesn't already exist
		if content.find(stream_id)? is false
			factory.request(stream_id).addTo content

		# close all other streams
		content.all().except(stream_id).close()

		# open request stream
		content.find(stream_id).open()


	@