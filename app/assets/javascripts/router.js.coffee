define ['backbone'], (Backbone) ->

	class Router extends Backbone.Router

		routes:
			""   : "render_home"
			"_=_": "redirect_home"

		render_home: ->
			console.log "render HomeView!"

		redirect_home: ->
			@navigate '', true

		initialize: ->
			Backbone.history.start
				pushState: true

	Router