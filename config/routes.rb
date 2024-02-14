Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :my_applications, path: :applications, param: :token do
        resources :chats, param: :number do
          resources :messages do
            get :search, param: :query, on: :collection # --> generates '/messages/search' and search_messagess_path
          end
        end
      end
    end
  end
end
