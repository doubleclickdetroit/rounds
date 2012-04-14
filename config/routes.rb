Draw::Application.routes.draw do
  scope 'api' do
    resources :rounds, :except => [:new,:edit] do
      resources :slides, :except => [:new,:edit]
    end

    resources :slides, :except => [:new,:edit] do
      resources :comments, :except => [:show,:new,:edit]
    end

    resources :comments, :except => [:show,:new,:edit]
  end
end
