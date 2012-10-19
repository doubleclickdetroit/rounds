define [], (require) ->

	facade  = require 'utils/facade'
	factory = require 'factories/window'


	# Subscriptions
	facade.subscribe 'window', 'init', ->
		# draw regions
		facade.publish 'regions', 'init'


	facade.subscribe 'window', 'reload', ->
		do window.location.reload