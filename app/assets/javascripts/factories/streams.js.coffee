define [], (require) ->

	RegionalMgr = require 'regional_manager'

	StreamCollection = require 'collections/streams'
	StreamModel      = require 'models/stream'
	StreamView       = require 'views/stream_view'
	StreamNavView    = require 'views/stream-nav_view'


	request: (stream_id) ->

		# find/create request stream region
		switch stream_id

			when 'manager'
				return RegionalMgr

			when 'nav'
				nav_view = new StreamNavView
				RegionalMgr.create 'nav', nav_view

			when 'pictures', 'sentences'
				stream_model = new StreamModel
					id        : stream_id
					collection: StreamCollection

				stream_view  = new StreamView
					id   : stream_id
					model: stream_model

				RegionalMgr.create stream_id, stream_view