Draw::Application.routes.draw do
  # match "/api/users/:fid/blocks/:blocked_user_fid" => 'blacklist_entries#create'
  # match "/api/users/:fid/unblocks/:blocked_user_fid" => 'blacklist_entries#create'

  scope 'api' do
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
