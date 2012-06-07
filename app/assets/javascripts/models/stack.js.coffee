define [], (require) ->

	$ = require "jquery"
	_ = require "underscore"
	Backbone = require "backbone"

	mediator = require "utils/mediator"
	Slides   = require "collections/slides"

	class Stack extends Backbone.Model

		urlRoot: "/api"

		initialize: ->

	Stack