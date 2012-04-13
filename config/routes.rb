Draw::Application.routes.draw do
  scope 'api' do
    # resources :rounds

    resources :slides do
      resources :comments, :except => [:show,:new,:edit]
    end

    resources :comments, :except => [:show,:new,:edit]
  end
end
