define [], (require) ->

	RegionalMgr = require 'regional_manager'

	request: (id) ->
		switch id

			when 'chrome'
				RegionalMgr.create 'chrome', $ 'body'

			when 'header'
				region = RegionalMgr.create 'header',  $ 'header'

			when 'content'
				region = RegionalMgr.create 'content',  $ '#main'

			when 'footer'
				region = RegionalMgr.create 'footer',  $ 'footer'


		# add region as child of the "chrome" region
		if region?
			RegionalMgr.get('chrome').add region
			region