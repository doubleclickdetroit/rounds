define [], (require) ->

	Region = require 'regions'

	StreamCollection = require 'collections/streams'
	StreamModel      = require 'models/stream'
	StreamView       = require 'views/stream_view'


	request: (id) ->
		switch id

			when 'pictures','sentences'
				stream_model = new StreamModel
					stream_name: id
					collection : StreamCollection

				stream_view  = new StreamView
					stream_name: id
					model      : stream_model

				return new Region id, stream_view