Draw::Application.routes.draw do

  # todo use :via for all matches

  # todo remove after dev
  resources :uploads

  # session
  match '/auth/facebook/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy', :as => :signout #, :via => :delete

  scope 'api' do
    scope 'users' do
      # own full user feed
      match '/me'   => 'user_feed#show', :via => :get
      scope 'me' do
        # own user activity by resource
        match '/rounds'      => 'rounds#index',      :via => :get
        match '/slides'      => 'slides#index',      :via => :get
        match '/comments'    => 'comments#index',    :via => :get
        match '/ballots'     => 'ballots#index',     :via => :get
        match '/invitations' => 'invitations#index', :via => :get
        match '/watchings'   => 'watchings#index',   :via => :get
      end

      # full user feed
      match '/:user_id'   => 'user_feed#show',        :via => :get
      # user activity by resource
      match '/:user_id/rounds'   => 'rounds#index',   :via => :get
      match '/:user_id/slides'   => 'slides#index',   :via => :get
      match '/:user_id/comments' => 'comments#index', :via => :get
      match '/:user_id/ballots'  => 'ballots#index',  :via => :get

      # blocking by User.id
      match '/block/:blocked_user_id'  => "blacklist_entries#create",  :via => :post
      match '/block/:blocked_user_id'  => "blacklist_entries#destroy", :via => :delete
    end

    # blocking by provider
    # todo clean up the match's
    match '/providers/:provider/users/:uid/block' => 'blacklist_entries#create', :via => :post
    match '/providers/:provider/users/:uid/block' => 'blacklist_entries#destroy', :via => :delete
    # todo clean up the match's
    # full user feed
    match '/providers/:provider/users/:uid/'         => 'user_feed#show', :via => :get
    # user activity / feeds by provider / uid
    match '/providers/:provider/users/:uid/rounds'   => 'rounds#index',   :via => :get
    match '/providers/:provider/users/:uid/slides'   => 'slides#index',   :via => :get
    match '/providers/:provider/users/:uid/comments' => 'comments#index', :via => :get
    match '/providers/:provider/users/:uid/ballots'  => 'ballots#index',  :via => :get


    resources :rounds, :except => [:index,:update,:new,:edit] do
      # todo DRY?
      match     'sentences' => 'slides#create', :type => 'Sentence', :via => :post
      match     'pictures'  => 'slides#create', :type => 'Picture',  :via => :post

      resources :slides, :except => [:new,:edit]

      match     'invitations/:invited_user_id' => 'invitations#create', :via => :post
      resources :invitations, :only => [:index,:destroy]

      resource  :watch, :controller => :watchings, only: [:create,:destroy]
      resource  :lock, :controller => :round_locks, :only => [:show,:create,:destroy] 
    end

    resources :slides, :except => [:index,:new,:edit] do
      resources :comments, :except => [:show,:new,:edit]

      resources :ballots, :only => [:index]
      match     'vote/:vote' => 'ballots#create'
    end

    ##### BEGIN MESS
    # todo cleaner
    match 'sentences' => 'slides#feed', :type => 'Sentence' 
    match 'pictures'  => 'slides#feed', :type => 'Picture' 

    # todo cleaner
    scope 'sentences' do
      match '/community' => 'slides#community', :type => 'Sentence'
      match '/friends' => 'slides#friends', :type => 'Sentence'
    end

    # todo cleaner
    scope 'pictures' do
      match '/community' => 'slides#community', :type => 'Picture'
      match '/friends' => 'slides#friends', :type => 'Picture'
    end
    ##### END MESS


    # todo needed?
    resources :comments, :except => [:index,:show,:new,:edit]
  end

  root :to => 'home#index'

end
