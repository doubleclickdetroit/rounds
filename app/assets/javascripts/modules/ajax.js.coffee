define [], (require) ->

	$ = require 'jquery'
	facade  = require 'utils/facade'


	subscribe = (id, fn) ->
		facade.subscribe 'ajax', id, fn


	# subscriptions
	subscribe 'complete', (xhr) ->
		facade.publish('window', 'reload') if xhr.status is 401
		@