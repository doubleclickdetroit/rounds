define [], (require) ->

	Region = require 'regions'

	request: (id) ->
		switch id

			when 'content' then new Region 'content', $ '#main'
			when 'header'  then new Region 'header',  $ 'header'
			when 'chrome'  then new Region 'chrome',  $ 'body'