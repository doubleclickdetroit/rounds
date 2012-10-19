define [], (require) ->

	_ = require 'underscore'
	Backbone = require 'backbone'

	nav_tmpl        = require 'text!templates/stacks/nav.html'
	stack_view_tmpl = require 'text!templates/stacks/view.html'


	class StreamView extends Backbone.View

		tagName   : 'section'
		className : 'container ui-round'
		stack_tmpl: _.template stack_view_tmpl

		events:
			'click header nav button' : 'handleStackChange'

		handleStackChange: (evt) ->
			$(evt.target).tab 'show'
			@options.model.request evt.target.id
			@

		constructor: (args...) ->
			super args...

			@options.model.on 'change:stacks', (model, stacks, data) =>
				@$el.html _.template nav_tmpl, 'stacks':stacks

			@options.model.on 'change:selected', (model, stack, data) =>
				@render stack.toJSON()

			@

		render: (slides) ->
			$stack = @stack_tmpl 'slides':slides
			# console.log 'render', slides
			@$el.find('article').remove().end().append $stack
			@


	StreamView