define [], (require) ->

	$ = require 'jquery'
	_ = require 'underscore'

	facade    = require 'utils/facade'
	factory   = require 'factories/streams'
	Singleton = require 'utils/singleton'


	# helper method
	subscribe = (id, fn) ->
		facade.subscribe 'streams', id, fn


	# streams manager
	class StreamsMgr extends Singleton

		streams = {}

		initialize: ->
			streams.pictures  = factory.request 'pictures'
			streams.sentences = factory.request 'sentences'


		render: (id) ->
			facade.publish 'streams', 'render', streams[id]


	# Subscriptions
	subscribe 'navigate', (stream_id) ->
		console.log "streams.navigate #{stream_id}"
		StreamsMgr.getInstance().render stream_id


	subscribe 'render', (stream) ->
		facade.publish 'regions', 'add_to_content', stream