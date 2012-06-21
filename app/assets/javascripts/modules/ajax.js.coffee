define [], (require) ->

	$ = require 'jquery'
	facade  = require 'utils/facade'


	subscribe = (id, fn) ->
		facade.subscribe 'ajax', id, fn


	# subscriptions
	subscribe 'complete', (xhr) ->
		do window.location.reload if xhr.status is 601
		@