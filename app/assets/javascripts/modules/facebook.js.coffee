define ['utils/facade','models/facebook'], (facade, Facebook) ->

	subscribe = (id, fn) -> facade.subscribe 'facebook', id, fn


	# init
	# Facebook.getInstance()