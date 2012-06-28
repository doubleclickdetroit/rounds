define [], (require) ->

	$ = require 'jquery'

	mediator  = require 'utils/mediator'
	AppRouter = require './router'
	config    = require './bootstrap'


	initialize: ->
		console.log 'App.config', config
		window.Router = new AppRouter
		do @setupAjaxHandling


	setupAjaxHandling: ->
		$(document)
			.ajaxComplete (evt, xhr) ->
				mediator.publish 'ajax', 'complete', xhr