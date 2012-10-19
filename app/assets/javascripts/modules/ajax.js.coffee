define [], (require) ->

	facade  = require 'utils/facade'


	# subscriptions
	facade.subscribe 'ajax', 'complete', (xhr) ->
		facade.publish('window', 'reload') if xhr.status is 401
		@