define ['utils/regions'], (Region) ->

	regions = {}

	all: ->
		regions

	get: (id) ->
		@all()[id]

	create: (id, view) ->
		if (regions[id] or null) is null
			regions[id] = new Region id, view
		@get id