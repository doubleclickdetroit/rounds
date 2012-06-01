define [], (require) ->

	class Singleton

		__instance = null

		@getInstance: ->
			if not @__instance?
				@__instance = new @
				@__instance.initialize()

			@__instance

		initialize: ->
			# throw new Error 'Unsupported operation on an Abstract Class.'

	Singleton