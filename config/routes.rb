Draw::Application.routes.draw do
  # match "/api/users/:fid/blocks/:blocked_user_fid" => 'blacklist_entries#create'
  # match "/api/users/:fid/unblocks/:blocked_user_fid" => 'blacklist_entries#destroy'

  scope 'api' do
    # scope 'users' do
    #   match "/:fid/activity"         => "feeds#activity"
    #   match "/:fid/friends_activity" => "feeds#friends_activity"
    #   match "/recent"                => "feeds#recent"
    #   match "/whats_hot"             => "feeds#whats_hot"
    # end

    devise_for :users 

    resources :rounds, :except => [:new,:edit] do
      resources :slides, :except => [:new,:edit]
    end

    resources :slides, :except => [:new,:edit] do
      resources :comments, :except => [:show,:new,:edit]
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

    resources :blacklist_entries, :only => [:create,:destroy]
  end

  # todo remove if devise doesnt _need_ this
  root :to => 'home#index'
end
