Draw::Application.routes.draw do

  # todo remove after dev
  resources :uploads

  # session
  get   '/auth/facebook/callback' => 'sessions#create'
  match '/signout' => 'sessions#destroy', :as => :signout #, :via => :delete

  scope 'api' do
    scope 'users' do
      # own full user feed
      get 'me' => 'user_feed#show'
      scope 'me' do
        # set user's facebook friends
        post 'friends'     => 'user_feed#friends'
        # own user activity by resource
        get  'rounds'      => 'rounds#index'
        get  'slides'      => 'slides#index'
        get  'comments'    => 'comments#index'
        get  'ballots'     => 'ballots#index'
        get  'invitations' => 'invitations#index'
        get  'watchings'   => 'watchings#index'
        get  'dibs'        => 'watchings#index',   type: 'Dib'
      end

      # full user feed
      get ':user_id'          => 'user_feed#show'
      # user activity by resource
      get ':user_id/rounds'   => 'rounds#index'
      get ':user_id/slides'   => 'slides#index'
      get ':user_id/comments' => 'comments#index'
      get ':user_id/ballots'  => 'ballots#index'

      # blocking by User.id
      post   'block/:blocked_user_id' => "blacklist_entries#create"
      delete 'block/:blocked_user_id' => "blacklist_entries#destroy"
    end

    # blocking by provider
    post   'providers/:provider/users/:uid/block'    => 'blacklist_entries#create'
    delete 'providers/:provider/users/:uid/block'    => 'blacklist_entries#destroy'
    # full user feed
    get    'providers/:provider/users/:uid/'         => 'user_feed#show'
    # user activity / feeds by provider / uid
    get    'providers/:provider/users/:uid/rounds'   => 'rounds#index'
    get    'providers/:provider/users/:uid/slides'   => 'slides#index'
    get    'providers/:provider/users/:uid/comments' => 'comments#index'
    get    'providers/:provider/users/:uid/ballots'  => 'ballots#index'


    resources :rounds, only: [:show,:destroy] do
      collection do
        post ':slide_limit'         => 'rounds#create'
        post ':slide_limit/private' => 'rounds#create', :private => true
      end
      # todo DRY?
      post     'sentences' => 'slides#create', type: 'Sentence'
      post     'pictures'  => 'slides#create', type: 'Picture'

      resources :slides, except: [:new,:edit]

      resources :invitations, :only => [:create,:index,:destroy]

      resource  :lock,  :controller => :round_locks, only: [:show,:create,:destroy]
      resource  :watch, :controller => :watchings,   only: [:create,:destroy]
      resource  :dib,   :controller => :watchings,   only: [:create,:destroy], type: 'Dib'
    end

    resources :slides, :except => [:index,:new,:edit] do
      resources :comments, :except => [:show,:new,:edit] do
        put :flag, action: :update, flag: true, on: :member
      end

      resources :ballots, :only => [:index]
      post      'vote/:vote' => 'ballots#create'
    end

    scope 'sentences', type: 'Sentence' do
      get ''          => 'slides#feed'
      get 'community' => 'slides#community'
      get 'friends'   => 'slides#friends'
      get 'private'   => 'slides#private'
    end

    scope 'pictures', type: 'Picture' do
      get ''          => 'slides#feed'
      get 'community' => 'slides#community'
      get 'friends'   => 'slides#friends'
      get 'private'   => 'slides#private'
    end

    resources :invitations, :only => [:update] do
      put :read, on: :member, action: :update, read: true
    end

    resources :comments, only: [:create,:destroy,:update] do
      put :flag, action: :update, flag: true, on: :member
    end
  end

  root :to => 'home#index'

  mount Resque::Server, at: '/resque'

end
