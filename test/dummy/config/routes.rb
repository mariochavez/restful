Dummy::Application.routes.draw do
  resources :documents
  resources :alternates
  resources :custom_notices, only: [:create, :update]
  resources :blocks, only: [:create, :update]

  namespace :admin do
    get "/new" => "prefix#new", :as => :new_document
    get "/:id" => "prefix#show", :as => :document

    get "/:id/edit" => "prefix#edit", :as => :edit_document

    get "/" => "prefix#index", :as => :documents
    post "/" => "prefix#create"
    put "/" => "prefix#update"
  end

  root "home#index"
end
