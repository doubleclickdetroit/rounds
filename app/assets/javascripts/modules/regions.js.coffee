define [], (require) ->

	$ = require 'jquery'
	_ = require 'underscore'

	facade  = require 'utils/facade'
	factory = require 'factories/regions'


	# helper method
	subscribe = (id, fn) ->
		facade.subscribe 'regions', id, fn


	# regions
	regions = {}


	# Subscriptions
	subscribe 'init', ->

		# create regions
		regions.chrome  = factory.request 'chrome'
		regions.header  = factory.request 'header'
		regions.content = factory.request 'content'

		# add chlid regions
		regions.chrome.add regions.header
		regions.chrome.add regions.content

		# temporary region
		window.chrome = regions.chrome



	subscribe 'add_to_header', (view) ->
		regions.header.add view



	subscribe 'add_to_content', (view) ->
		regions.content.add view



	subscribe 'remove_from_header', (id) ->
		regions.header.remove id



	subscribe 'remove_from_content', (id) ->
		regions.content.remove id