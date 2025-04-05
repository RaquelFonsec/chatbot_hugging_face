Rails.application.routes.draw do
  root "messages#index"  # A página inicial será o índice de mensagens
  resources :messages, only: [:index, :create]  # Permite tanto GET quanto POST em /messages
end
