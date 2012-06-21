define [], (require) ->

	$ = require 'jquery'
	_ = require 'underscore'

	regions = {}
	facade  = require 'utils/facade'
	factory = require 'factories/window'


	subscribe = (id, fn) ->
		facade.subscribe 'window', id, fn


	# Subscriptions
	subscribe 'init', ->

		# draw regions
		facade.publish 'regions', 'init'