define [], (require) ->

	facade = require 'utils/facade'

	_ = require 'underscore'
	Backbone = require 'backbone'


	class RoundContentView extends Backbone.View

		tagName  : 'ul'
		className: 'ui-slides'

		events:
			'click li' : 'toggleFullscreen'

		initialize: (id, slide_view) ->
			super @

			@id = id
			@slide_view = slide_view

		toggleFullscreen: ->
			facade.publish 'rounds', 'fullscreen'

		add: (data) =>
			view = new @slide_view model:data
			@$el.append view.render().el