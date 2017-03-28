Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/callbacks' }

  authenticated :user do
    root 'inventory/workplaces#index', as: :authenticated_root
  end

  devise_scope :user do
    root 'devise/sessions#new'
  end

  # Инвентаризация
  namespace :inventory do
    # Отделы
    resources :workplace_counts, param: :workplace_count_id, except: :edit
    # Рабочие места
    resources :workplaces, param: :workplace_id

    # Запросы с ЛК
    # Инициализация
    get 'lk_invents/init/:tn', to: 'lk_invents#init', constraints: { tn: /\d+/ }
    # Получить данные по выбранном отделу (список РМ, макс. число, список работников отдела)
    get 'lk_invents/show_division_data/:division', to: 'lk_invents#show_division_data', constraints: { division: /\d+/ }
    # Получить данные о системном блоке из аудита
    get 'lk_invents/get_data_from_audit/:invent_num', to: 'lk_invents#get_data_from_audit',
        constraints: { invent_num: /.*/ }
    # Записать данные о РМ
    post 'lk_invents/create_workplace', to: 'lk_invents#create_workplace'
    # Получить данные о РМ
    get 'lk_invents/edit_workplace/:workplace_id', to: 'lk_invents#edit_workplace',
        constraints: { workplace_id: /\d+/ }
    # Обновить данные о РМ
    patch 'lk_invents/update_workplace/:workplace_id', to: 'lk_invents#update_workplace',
          constraints: { workplace_id: /\d+/ }
    # Удалить РМ
    delete 'lk_invents/delete_workplace/:workplace_id', to: 'lk_invents#delete_workplace',
           constraints: { workplace_id: /\d+/ }
    # Создать PDF файл со списком РМ для отдела
    get 'lk_invents/generate_pdf/:division', to: 'lk_invents#generate_pdf', constraints: { division: /\d+/ }
  end

  # Эталоны
  namespace :standart do
    resources :system_units
  end

  # Получить html-код кнопки "Добавить запись"
  get 'link/new_record', to: 'application#link_to_new_record'
end
