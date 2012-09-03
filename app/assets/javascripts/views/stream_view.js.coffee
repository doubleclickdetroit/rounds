define [], (require) ->

	_ = require 'underscore'
	Backbone = require 'backbone'

	nav_tmpl = require 'text!templates/stack_nav.html'
	stack_view_tmpl = require 'text!templates/stack_view.html'


	class StreamView extends Backbone.View

		tagName   : 'section'
		className : 'ui-round'
		stack_tmpl: _.template stack_view_tmpl

		events:
			'click header nav a' : 'handleStackChange'

		handleStackChange: (evt) ->
			evt.preventDefault()
			@options.model.request evt.target.id
			@

		constructor: (args...) ->
			super args...

			@options.model.on 'change:stacks', (model, stacks, data) =>
				@$el.html _.template nav_tmpl, 'id':@id, 'stacks':stacks

			@options.model.on 'change:selected', (model, stack, data) =>
				@render stack.toJSON()

			@

		render: (slides) ->
			$stack = @stack_tmpl 'slides':slides
			console.log 'render', slides
			@$el.find('article').remove().end().append $stack
			@

		onOpen: ->
			# console.log "stream_view #{@options.id} onShow"
			@$el.show()
			@

		onClose: ->
			# console.log "stream_view #{@options.id} onClose"
			@$el.hide()
			@


	StreamView