Draw::Application.routes.draw do
  # todo use :via for all matches
  
  scope 'api' do
    # resources :blacklist_entries, :only => [:create,:destroy]
    scope 'users' do
      match '/block/:fid'   => "blacklist_entries#create"
      match '/unblock/:fid' => "blacklist_entries#destroy"
    end
    # scope 'users' do
    #   match "/:fid/activity"         => "feeds#activity"
    #   match "/:fid/friends_activity" => "feeds#friends_activity"
    #   match "/recent"                => "feeds#recent"
    #   match "/whats_hot"             => "feeds#whats_hot"
    # end

    devise_for :users 

    resources :rounds, :except => [:new,:edit] do
      # todo DRY?
      match     'sentences' => 'slides#create', :type => 'Sentence', :via => :post
      match     'pictures'  => 'slides#create', :type => 'Picture',  :via => :post

      resources :slides, :except => [:new,:edit]

      match     'invite/:invited_fid' => 'invitations#create'
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
      match '/recent' => 'slides#recent', :type => 'Sentence'
      match '/friends' => 'slides#friends', :type => 'Sentence'
    end

    # todo cleaner
    scope 'pictures' do
      match '/recent' => 'slides#recent', :type => 'Picture'
      match '/friends' => 'slides#friends', :type => 'Picture'
    end
    ##### END MESS

    resources :comments, :except => [:show,:new,:edit]
  end

  # todo remove if devise doesnt _need_ this
  root :to => 'home#index'
end
