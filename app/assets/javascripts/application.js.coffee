define [], (require) ->

	$ = require 'jquery'

	AppRouter = require './router'
	facade    = require 'utils/facade'
	bootstrap = require 'bootstrap_app'


	setupAjaxHandling = ->
		$(document)
			.ajaxComplete (evt, xhr) ->
				facade.publish 'ajax', 'complete', xhr


	initialize: ->
		# console.log 'bootstrap data:', bootstrap
		new AppRouter
		do setupAjaxHandling