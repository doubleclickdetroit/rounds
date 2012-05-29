Draw::Application.routes.draw do
  # todo use :via for all matches

  # todo remove after dev
  resources :uploads

  # session
  match '/auth/facebook/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy', :as => :signout #, :via => :delete

  scope 'api' do

    # blocking
    scope 'users' do
      # blocking by User.id
      match '/block/:blocked_user_id' => "blacklist_entries#create", :via => :post
      match '/block/:blocked_user_id' => "blacklist_entries#destroy", :via => :delete
    end
    # blocking by provider
    # todo clean up the match's
    match '/providers/:provider/users/:uid/block' => 'blacklist_entries#create', :via => :post
    match '/providers/:provider/users/:uid/block' => 'blacklist_entries#destroy', :via => :delete


    # user activity / feeds
    # todo clean up the match's
    match '/providers/:provider/users/:uid/rounds'   => 'rounds#index',   :via => :get
    match '/providers/:provider/users/:uid/slides'   => 'slides#index',   :via => :get
    match '/providers/:provider/users/:uid/comments' => 'comments#index', :via => :get
    

    resources :rounds, :except => [:new,:edit] do
      # todo DRY?
      match     'sentences' => 'slides#create', :type => 'Sentence', :via => :post
      match     'pictures'  => 'slides#create', :type => 'Picture',  :via => :post

      resources :slides, :except => [:new,:edit]

      match     'invitations/:invited_user_id' => 'invitations#create', :via => :post
      resources :invitations, :only => [:index,:destroy]

      resource  :round_lock, :only => [:show,:create,:destroy] do
        resources :watchings, :only => :create
      end
    end

    resources :slides, :except => [:new,:edit] do
      resources :comments, :except => [:show,:new,:edit]

      match     'vote/:vote' => 'ballots#create'

      resources :watchings, :only => :create
      # todo why do i need this? ... should it take an id?
      # the resource is singular from the perspective of a 
      # single user, but the Slide has_many
      match     'watchings' => 'watchings#destroy', :via => :delete
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
    resources :comments, :except => [:show,:new,:edit]
  end


  root :to => 'home#index'

end
