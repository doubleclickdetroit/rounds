define [], (require) ->

	RegionalMgr = require 'regional_manager'

	window.mgr = RegionalMgr

	request: (id) ->
		switch id

			when 'regional_manager'
				RegionalMgr

			when 'header'
				region = RegionalMgr.create 'header',  $('#header'), true

			when 'content'
				region = RegionalMgr.create 'content',  $('#main'), true

			when 'footer'
				region = RegionalMgr.create 'footer',  $('footer'), true