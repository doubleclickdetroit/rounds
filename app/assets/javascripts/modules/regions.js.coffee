define ['utils/facade','factories/regions','regional_manager'], (facade, factory, RegionalMgr) ->

	# helper method
	subscribe = (id, fn) ->
		facade.subscribe 'regions', id, fn


	# Subscriptions
	subscribe 'init', ->

		# create regions
		factory.request 'chrome'
		factory.request 'header'
		factory.request 'content'
		factory.request 'footer'

		# temporary region access
		window.chrome = RegionalMgr.get 'chrome'