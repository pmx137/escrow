App::Application.routes.draw do
  get "wyloguj_sie" => "sessions#destroy", :as => :logout
  get "zaloguj_sie" => "sessions#new", :as => :login
  get "zaloz_konto" => "users#new", :as => :signup

  match '/wplac(/:id)'=> 'payments#new_payment', :as=> :new_payment
  match '/popros(/:id)'=> 'payments#new_payment', :as=> :ask_payment
  match '/zaliczkuj(/:id)'=> 'payments#create_payment', :as=> :create_payment
  match '/szczegoly_zaliczki(/:url_token)'=> 'payments#payment_details', :as=> :payment_details
  match '/pobierz(/:url)'=> 'payments#get_title', :as=> :pay_get_title

  match '/konto'=> 'profiles#index', :as=> :pro_index
  match '/zaliczka(/:id)'=> 'profiles#details', :as=> :pro_details
  match '/edytuj'=> 'profiles#edit', :as=> :pro_edit
  match '/zapisz_dane'=> 'profiles#save', :as=> :pro_save
  match '/haslo'=> 'profiles#pass', :as=> :pro_pass
  match '/zmien_haslo'=> 'profiles#change_pass', :as=> :pro_change_pass
  match '/zrob_przelew(/:url_token)'=> 'profiles#pay_me', :as=> :pro_pay_me
  match '/zaplac(/:url_token)'=> 'profiles#pay_recipient', :as=> :pro_pay_recipient
  match '/wyplac(/:url_token)'=> 'profiles#ask_for_payment', :as=> :pro_ask_for_payment
  match '/usun(/:url_token)'=> 'profiles#delete', :as=> :pro_delete
  match '/edytuj_konto(/:url_token)'=> 'profiles#edit_account', :as=> :pro_edit_account
  match '/zapisz_konto(/:url_token)'=> 'profiles#save_account', :as=> :pro_save_account

  match '/spor(/:id)'=> 'disputes#index', :as=> :dis_index
  match '/dodaj_spor(/:id)'=> 'disputes#add_dispute', :as=> :dis_add_dispute
  match '/edytuj_spor(/:id)'=> 'disputes#edit_dispute', :as=> :dis_edit_dispute
  match '/zapisz_spor'=> 'disputes#save', :as=> :dis_save
  match '/szczegoly_sporu(/:id)'=> 'disputes#details', :as=> :dis_create
  match '/dodaj_komentarz(/:id)'=> 'disputes#add_comment', :as=> :dis_add_comment

  match '/home' => 'home#index', :as=> :home
  match '/kontakt'=> 'home#contact', :as=> :contact
  match '/wyslij_kontakt' => 'home#create_contact', :as=> :contact_me
  match '/cele_charytatywne'=> 'home#mission', :as=> :mission
  match '/regulamin'=> 'home#regulations', :as=> :regulations

  root :to => 'home#index'

  resources :users
  resources :sessions
  resources :password_resets

  match '/:controller(/:action)'
  match '(/:controller/:action(/:id))'
end
