Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/callbacks' }

  authenticated :user do
    root 'workplaces#index', as: :authenticated_root
  end

  devise_scope :user do
    root 'devise/sessions#new'
  end

  # Инвентаризация
  resources :workplaces, param: :workplace_id

  # Отделы
  resources :workplace_counts, param: :workplace_count_id, except: :edit do
    get 'link/new_record',    to: 'workplace_counts#link_to_new_record',  on: :collection
  end

  # Запросы с ЛК
  # Инициализация
  get 'lk_invents/init/:tn', to: 'lk_invents#init', constraints: { tn: /\d+/ }
  # Получить данные по выбранном отделу (список РМ, макс. число, список работников отдела)
  get 'lk_invents/show_division_data/:division', to: 'lk_invents#show_division_data', constraints: { division: /\d+/ }
  # Записать данные о РМ
  post 'lk_invents/create_workplace', to: 'lk_invents#create_workplace'

  # Эталоны
  resources :system_units
end
