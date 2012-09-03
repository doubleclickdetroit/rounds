define ['utils/facade','factories/window'], (facade, factory) ->

	subscribe = (id, fn) ->
		facade.subscribe 'window', id, fn


	# Subscriptions
	subscribe 'init', ->

		# draw regions
		facade.publish 'regions', 'init'


	subscribe 'reload', ->
		do window.location.reload