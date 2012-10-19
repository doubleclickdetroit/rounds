define [], (require) ->

	$ = require 'jquery'
	_ = require 'underscore'
	Backbone = require 'backbone'


	class Region

		# Backbone defaults for Region
		Backbone.View.prototype.onOpen    = -> @$el.show()
		Backbone.View.prototype.onClose   = -> @$el.hide()
		Backbone.View.prototype.onDestroy = -> @onClose()
		Backbone.View.prototype.doDestroy = ->
			@remove()
			@unbind()
			@onDestroy()



		# Helper(s)
		find = (items, props) ->
			_.find items, (item) ->
				return _.all _.keys(props), (prop) ->
					return item[prop] == props[prop]

		open = (id) ->
			@view.onOpen() if @view?

			children = if id? then [ @find id ] else @children
			_.each children, (child) -> child.open()

		close = (id) ->
			@view?.onClose()

			children = if id? then [ @find id ] else @children
			_.each children, (child) -> child.close()



		# Constructor
		constructor: (id, view) ->
			is_view   = view instanceof Backbone.View

			@id       = id
			@view     = if is_view then view     else null
			@$el      = if is_view then view.$el else view
			@el       = if is_view then view.el  else view.get 0
			@children = []



		# CRUD
		addTo: (parent) ->
			parent.add(@) if parent instanceof Region
			@

		add: (child) ->
			@children.push child
			@$el.append child.$el
			@

		remove: (id) ->
			child = @find id
			if @children?.indexOf( child ) >= 0
				@children?.splice @children.indexOf( child ), 1
				child.removeAll()
				child.view?.doDestroy()
			@

		removeAll: ->
			@remove @children[0] while @children.length



		# Selectors
		find: (child) ->
			return find @children, id:child if typeof child is 'string'
			child

		all: ->
			methods = all:@all, close:@close, except:@except, open:@open, _children: @children or @._children
			$.extend [], @children or @._children, methods

		except: (id) ->
			selection = if $.isArray(@) then @ else [@]

			# determine id arg is string
			if id? and typeof id is 'string'
				index = _.indexOf selection, find selection, "id":id

				# remove the item if it is found within the array
				selection.splice( index, 1 ) if index >= 0

			selection



		# Rendering
		open: (id) ->
			selection = if $.isArray(@) then @ else [@]
			_.each selection, (region) => open.call region, id
			@

		close: (id) ->
			selection = if $.isArray(@) then @ else [@]
			_.each selection, (region) => close.call region, id
			@

		toggle: (id) ->
			selection = if $.isArray(@) then @ else [@]
			_.each selection, (region) => close.call region, id
			@

		visible: ->
			@$el.is ':visible'


	Region