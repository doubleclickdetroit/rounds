define [], (require) ->

	RegionalMgr = require 'regional_manager'

	RoundHeader  = require 'views/rounds/header'
	RoundContent = require 'views/rounds/content'

	SlideView        = require 'views/rounds/slide'
	SlidesCollection = require 'collections/rounds'


	request: (partial_name, round_id) ->
		window.RegionalMgr = RegionalMgr

		# find/create request rounds region
		switch partial_name

			when 'manager'
				return RegionalMgr

			when 'header'
				RegionalMgr.create 'rounds', new RoundHeader

			when 'content'
				collection = new SlidesCollection id:round_id
				roundView  = new RoundContent round_id, SlideView

				collection.bind 'add', roundView.add
				collection.bind 'reset', -> collection.each roundView.add
				collection.fetch()

				RegionalMgr.create 'rounds', roundView