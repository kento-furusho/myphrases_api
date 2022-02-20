Rails.application.routes.draw do
  namespace :api do
      namespace :v1, defaults: { format: :json } do
        mount_devise_token_auth_for "User", at: "auth", controllers: {
          registrarions: 'api/v1/registrations',
          sessions: 'devise_token_auth/sessions'
        }
        resources :users, only:[:index]
    end
  end
end
