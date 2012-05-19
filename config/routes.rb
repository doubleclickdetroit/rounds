Draw::Application.routes.draw do
  # todo use :via for all matches
  
  match '/auth/facebook/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy', :as => :signout #, :via => :delete

  scope 'api' do

    # resources :blacklist_entries, :only => [:create,:destroy]
    scope 'users' do
      match '/block/:user_id'   => "blacklist_entries#create"
      match '/unblock/:user_id' => "blacklist_entries#destroy"
    end
    # scope 'users' do
    #   match "/:user_id/activity"         => "feeds#activity"
    #   match "/:user_id/friends_activity" => "feeds#friends_activity"
    #   match "/community"                => "feeds#community"
    #   match "/whats_hot"             => "feeds#whats_hot"
    # end

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

    resources :comments, :except => [:show,:new,:edit]
  end

  # todo needed?
  root :to => 'home#index'
end
