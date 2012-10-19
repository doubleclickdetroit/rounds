define [], (require) ->

	RegionalMgr = require 'regional_manager'

	StreamModel      = require 'models/stream'
	StreamCollection = require 'collections/streams'

	StreamView    = require 'views/streams/view'
	StreamHeader  = require 'views/streams/header'
	StreamFooter  = require 'views/streams/footer'
	StreamContent = require 'views/streams/content'


	request: (stream_id) ->
		window.RegionalMgr = RegionalMgr

		# find/create request streams region
		switch stream_id

			when 'manager'
				return RegionalMgr

			when 'header'
				RegionalMgr.create 'stream', new StreamHeader

			when 'footer'
				RegionalMgr.create 'stream', new StreamFooter

			when 'content'
				RegionalMgr.create 'stream', new StreamContent

			when 'pictures', 'sentences'
				stream_model = new StreamModel
					id        : stream_id
					collection: StreamCollection

				stream_view  = new StreamView
					id   : stream_id
					model: stream_model

				RegionalMgr.create stream_id, stream_view