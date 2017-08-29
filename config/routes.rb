Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "bet#index"
  match "/botlite" => 'bet#personal', via: [:get]
  match "/pe2deorfd" => 'bet#place', via: [:get]
end
