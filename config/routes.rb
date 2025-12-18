PurchaseKit::Pay::Engine.routes.draw do
  resources :purchases, only: [:create]
  resource :webhooks, only: [:create]
end
