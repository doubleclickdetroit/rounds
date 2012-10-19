define [], (require) ->

	facade  = require 'utils/facade'
	factory = require 'factories/regions'


	# Subscriptions
	facade.subscribe 'regions', 'init', ->
		# create regions
		factory.request 'header'
		factory.request 'content'
		factory.request 'footer'

		# temporary region access
		window.regional_manager = factory.request 'regional_manager'