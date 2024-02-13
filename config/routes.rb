Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :my_applications,path: :applications, param: :token do
        resources :chats, param: :number do
          resources :messages
        end
      end
    end
  end
end
