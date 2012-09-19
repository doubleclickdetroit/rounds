define ['utils/regions'], (Region) ->

	regions = {}

	all: ->
		regions

	find: (id) ->
		@all()[id]

	create: (id, view, save = false) ->
		region = new Region id, view
		if (save and ((regions[id] or null) is null))
			regions[id] = region
		region