Draw::Application.routes.draw do
  # todo use :via for all matches
  
  resources :round_locks

  scope 'api' do
    scope 'users' do
      match '/block/:fid'   => "blacklist_entries#create"
      match '/unblock/:fid' => "blacklist_entries#destroy"
    end

    devise_for :users 

    resources :rounds, :except => [:new,:edit] do
      resources :slides, :except => [:new,:edit]
    end

    resources :slides, :except => [:new,:edit] do
      resources :comments, :except => [:show,:new,:edit]
      resources :watchings, :only => :create
      match     'watchings' => 'watchings#destroy', :via => :delete
    end

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

    resources :comments, :except => [:show,:new,:edit]

    # resources :blacklist_entries, :only => [:create,:destroy]

    # scope 'users' do
    #   match "/:fid/activity"         => "feeds#activity"
    #   match "/:fid/friends_activity" => "feeds#friends_activity"
    #   match "/recent"                => "feeds#recent"
    #   match "/whats_hot"             => "feeds#whats_hot"
    # end

  end

  # todo remove if devise doesnt _need_ this
  root :to => 'home#index'
end
