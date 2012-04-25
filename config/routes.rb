Draw::Application.routes.draw do
  # match "/api/users/:fid/blocks/:blocked_user_fid" => 'blacklist_entries#create'
  # match "/api/users/:fid/unblocks/:blocked_user_fid" => 'blacklist_entries#destroy'

  scope 'api' do
    # match "/users/:fid/activity"         => "feeds#activity"
    # match "/users/:fid/friends_activity" => "feeds#friends_activity"
    # match "/users/recent"                => "feeds#recent"
    # match "/users/whats_hot"             => "feeds#whats_hot"
    scope 'users' do
      match "/:fid/activity"         => "feeds#activity"
      match "/:fid/friends_activity" => "feeds#friends_activity"
      match "/recent"                => "feeds#recent"
      match "/whats_hot"             => "feeds#whats_hot"
    end

    devise_for :users 

    resources :rounds, :except => [:new,:edit] do
      resources :slides, :except => [:new,:edit]
    end

    resources :slides, :except => [:new,:edit] do
      resources :comments, :except => [:show,:new,:edit]
    end

    resources :comments, :except => [:show,:new,:edit]

    resources :blacklist_entries, :only => [:create,:destroy]
  end

  # todo remove if devise doesnt _need_ this
  root :to => 'home#index'
end
