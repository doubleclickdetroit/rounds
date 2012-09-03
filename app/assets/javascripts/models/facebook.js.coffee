define ['backbone', 'utils/singleton', 'utils/facade'], (Backbone, Singleton, facade) ->

	User = new ( Backbone.Model.extend() )


	class Facebook extends Singleton

		APP_ID = 239810862786452

		initialize: ->
			window.user = User
			window.fbAsyncInit = initializeAPI
			do createRootNode
			do loadAsyncAPI


		createRootNode = ->
			$('body').prepend '<div id="fb-root">'


		loadAsyncAPI = ->
			d   = document
			id  = 'facebook-jssdk'
			ref = d.getElementsByTagName('script')[0]

			if d.getElementById(id) is null
				js       = d.createElement 'script'
				js.id    = id
				js.async = true
				js.src   = '//connect.facebook.net/en_US/all.js'
				ref.parentNode.insertBefore js, ref


		initializeAPI = ->
			# initialize API
			FB.init
				appId  : APP_ID
				status : true, # check login status
				cookie : true, # enable cookies to allow the server to access the session
				frictionlessRequests: true

			# synchronous login check
			FB.getLoginStatus delegate_status


		delegate_status = (response) ->
			switch response.status
				when 'connected' then do set_user
				when 'unknown'   then do prompt_login


		prompt_login = ->
			FB.login delegate_status # loop login refusals :)


		set_user = ->
			FB.api '/me', (response) ->
				me_keys = "username name first_name last_name email id link gender".split ' '
				User.set _.pick( response, me_keys )

			FB.api '/me/friends', (response) ->
				User.set 'friends', response.data
				friends =  provider: 'facebook', uids: _.pluck response.data, 'id'
				facade.publish 'friends', 'update', friends


	Facebook