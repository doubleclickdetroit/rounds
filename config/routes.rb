Draw::Application.routes.draw do
  devise_for :users

  scope 'api' do
    resources :rounds, :except => [:new,:edit] do
      resources :slides, :except => [:new,:edit]
    end

    resources :slides, :except => [:new,:edit] do
      resources :comments, :except => [:show,:new,:edit]
    end

    resources :comments, :except => [:show,:new,:edit]
  end

  # todo remove if devise doesnt _need_ this
  root :to => 'home#index'
end
