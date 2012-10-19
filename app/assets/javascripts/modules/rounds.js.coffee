define [], (require) ->

	Singleton = require 'utils/singleton'
	facade    = require 'utils/facade'
	factory   = require 'factories/rounds'


	# view store
	class Manager extends Singleton

		header  = null
		content = null


		initialize: ->
			# find manager to manage child regions
			header  = factory.request('manager').find 'header'
			content = factory.request('manager').find 'content'
			@

		open: (round_id) ->
			# create partials as they don't yet exist
			factory.request('header').addTo(header).open()
			factory.request('content', round_id).addTo(content).open()

		close: ->
			# close child regions
			region.close('rounds') for region in [header, content]

		remove: ->
			# remove all child regions
			region.remove('rounds') for region in [header, content]

		toggleHeader: ->
			$header  = header.find('rounds')
			$header[if $header.visible() then 'close' else 'open']()



	# Subscriptions
	facade.subscribe 'rounds', 'navigate', (round_id) ->
		Manager.getInstance().open round_id

	facade.subscribe 'rounds', 'fullscreen', ->
		Manager.getInstance().toggleHeader()



	facade.subscribe 'router', 'navigate', (id) ->
		# find manager to close/remove regions
		if id isnt 'rounds'
			Manager.getInstance().remove()


	@