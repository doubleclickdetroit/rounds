define [], (require) ->

	$ = require "jquery"
	_ = require "underscore"

	facade = require "utils/facade"

	facade.subscribe 'renderSlides', (context) ->
		# console.log 'renderSlides', context

	facade.subscribe 'renderSlide', (context) ->
		# console.log 'renderSlide', context