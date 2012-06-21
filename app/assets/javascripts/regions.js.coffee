define [], (require) ->

	_ = require 'underscore'
	Backbone = require 'backbone'


	class Region

		# Backbone defaults for Region
		Backbone.View.prototype.onOpen    = ->
		Backbone.View.prototype.onClose   = ->
		Backbone.View.prototype.onDestroy = ->
		Backbone.View.prototype.doDestroy = ->
			@remove()
			@unbind()
			@onDestroy()


		# Helper(s)
		find = (items, props) ->
			_.find items, (item) ->
				return _.all _.keys(props), (prop) ->
					return item[prop] == props[prop]


		# Constructor
		constructor: (id, view) ->
			is_view   = view instanceof Backbone.View

			@id       = id
			@view     = if is_view then view     else null
			@$el      = if is_view then view.$el else view
			@el       = if is_view then view.el  else view.get 0
			@children = []


		# CRUD
		add: (child) ->
			@children.push child
			@$el.append child.$el
			@

		find: (child) ->
			return find @children, id:child if typeof child is 'string'
			child

		remove: (id) ->
			child = @find id
			if @children?.indexOf( child ) >= 0
				@children?.splice @children.indexOf( child ), 1
				child.removeAll()
				child.view?.doDestroy()
			@

		removeAll: ->
			@remove @children[0] while @children.length


		# Rendering
		open: (id) ->
			if @view?
				@view.render()
				@view.onOpen()

			children = if id? then [ @find id ] else @children
			_.each children, (child) -> child.open()
			@

		close: (id) ->
			@view?.onClose()

			children = if id? then [ @find id ] else @children
			_.each children, (child) -> child.close()
			@


	Region