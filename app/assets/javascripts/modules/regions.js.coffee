define ['utils/facade','factories/regions'], (facade, factory) ->

	# helper method
	subscribe = (id, fn) ->
		facade.subscribe 'regions', id, fn


	# Subscriptions
	subscribe 'init', ->

		# create regions
		factory.request 'header'
		factory.request 'content'
		factory.request 'footer'

		# temporary region access
		window.regional_manager = factory.request 'regional_manager'