define [], (require) ->

	$ = require 'jquery'

	mediator  = require 'utils/mediator'
	AppRouter = require './router'


	initialize: ->
		window.Router = new AppRouter
		do @setupAjaxHandling


	setupAjaxHandling: ->
		$(document)
			.ajaxComplete (evt, xhr) ->
				mediator.publish 'ajax', 'complete', xhr