define [], (require) ->

	$ = require 'jquery'

	mediator  = require "utils/mediator"
	AppRouter = require "./router"

	initialize: ->
		do new AppRouter
		do @setupAjaxHandling

	setupAjaxHandling: ->
		$(document)
			.ajaxComplete (evt, xhr) ->
				mediator.publish 'ajax', 'complete', xhr


	# StreamView (View)
		# SlidesView (View)
		# Slides (Collection)
			# Slide (Model)
			# SlideView (View)
