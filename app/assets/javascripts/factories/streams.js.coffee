define [], (require) ->

	RegionalMgr = require 'regional_manager'

	StreamCollection = require 'collections/streams'
	StreamModel      = require 'models/stream'
	StreamView       = require 'views/stream_view'
	StreamHeader     = require 'views/stream-header'
	StreamFooter     = require 'views/stream-footer'


	request: (stream_id) ->

		# find/create request stream region
		switch stream_id

			when 'manager'
				return RegionalMgr

			when 'header'
				header = new StreamHeader
				RegionalMgr.create 'stream', header

			when 'footer'
				footer = new StreamFooter
				RegionalMgr.create 'stream', footer

			when 'pictures', 'sentences'
				stream_model = new StreamModel
					id        : stream_id
					collection: StreamCollection

				stream_view  = new StreamView
					id   : stream_id
					model: stream_model

				RegionalMgr.create stream_id, stream_view