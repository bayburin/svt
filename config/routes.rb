Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/callbacks' }

  authenticated :user do
    root 'invent/workplaces#index', as: :authenticated_root
    # root to: redirect(path: '/invent/workplaces'), as: :authenticated_root
  end

  devise_scope :user do
    root 'devise/sessions#new'
  end

  resources :users

  # Инвентаризация
  namespace :invent do
    # Отделы
    resources :workplace_counts, param: :workplace_count_id, except: :edit do
      post 'create_list', to: 'workplace_counts#create_list', on: :collection
    end
    # Рабочие места
    resources :workplaces, param: :workplace_id do
      collection do
        # Вывести все РМ списком
        get 'list_wp', to: 'workplaces#list_wp'
        # Подтвердить/отклонить конфигурацию РМ
        put 'confirm', to: 'workplaces#confirm'
        # Получить данные о системном блоке из аудита
        get 'pc_config_from_audit/:invent_num', to: 'workplaces#pc_config_from_audit', constraints: { invent_num: /.*/ }
        # Расшифровать файл конфигурации ПК, загруженный пользователем.
        post 'pc_config_from_user', to: 'workplaces#pc_config_from_user'
        # Скачать скрипт для генерации файла конфигурации ПК
        get 'pc_script', to: 'workplaces#send_pc_script'
      end

      delete 'hard_destroy', to: 'workplaces#hard_destroy', on: :member
    end

    # Запросы с ЛК
    # Проверка доступа к разделу "Вычислительная техника" в ЛК.
    get 'lk_invents/svt_access', to: 'lk_invents#svt_access'
    # Инициализация
    get 'lk_invents/init_properties', to: 'lk_invents#init_properties'
    # Получить данные по выбранном отделу (список РМ, макс. число, список работников отдела)
    get 'lk_invents/show_division_data/:division', to: 'lk_invents#show_division_data', constraints: { division: /\d+/ }
    # Получить данные о системном блоке из аудита
    get 'lk_invents/pc_config_from_audit/:invent_num',
        to: 'lk_invents#pc_config_from_audit',
        constraints: { invent_num: /.*/ }
    # Расшифровать файл конфигурации ПК, загруженный пользователем.
    post 'lk_invents/pc_config_from_user', to: 'lk_invents#pc_config_from_user'
    # Записать данные о РМ
    # post 'lk_invents/create_workplace', to: 'lk_invents#create_workplace'
    # Получить данные о РМ
    # get 'lk_invents/edit_workplace/:workplace_id', to: 'lk_invents#edit_workplace', constraints: { workplace_id: /\d+/ }
    # Обновить данные о РМ
    # patch 'lk_invents/update_workplace/:workplace_id', to: 'lk_invents#update_workplace', constraints: { workplace_id: /\d+/ }
    # Удалить РМ
    # delete 'lk_invents/destroy_workplace/:workplace_id', to: 'lk_invents#destroy_workplace', constraints: { workplace_id: /\d+/ }
    # Создать PDF файл со списком РМ для отдела
    get 'lk_invents/generate_pdf/:division', to: 'lk_invents#generate_pdf', constraints: { division: /\d+/ }
    # Скачать скрипт для генерации файла конфигурации ПК
    get 'lk_invents/pc_script', to: 'lk_invents#send_pc_script'
    # Проверить, существует ли техника с указанным инвентарным номером
    get 'lk_invents/existing_item', to: 'lk_invents#existing_item'

    resources :items, only: [:index, :show, :edit, :destroy], param: :item_id do
      collection do
        get 'avaliable/:type_id', to: 'items#avaliable', constraints: { type_id: /\d+/ }
        get 'busy/:type_id', to: 'items#busy', constraints: { type_id: /\d+/ }
      end
    end

    resources :vendors, only: [:index, :create, :destroy], param: :vendor_id
    resources :models, param: :model_id
  end

  # Эталоны
  namespace :standard do

  end

  # Склад
  namespace :warehouse do
    resources :items
    resources :orders, only: [:new, :edit, :destroy] do
      get 'in', to: 'orders#index_in', on: :collection
      get 'out', to: 'orders#index_out', on: :collection
      get 'archive', to: 'orders#archive', on: :collection
      get 'print', to: 'print', on: :member
      post 'create_in', to: 'orders#create_in', on: :collection
      post 'create_out', to: 'orders#create_out', on: :collection
      post 'execute_in', to: 'orders#execute_in', on: :member
      post 'execute_out', to: 'orders#execute_out', on: :member
      post 'prepare_to_deliver', to: 'orders#prepare_to_deliver', on: :member
      put 'update_in', to: 'orders#update_in', on: :member
      put 'update_out', to: 'orders#update_out', on: :member
      put 'confirm_out', to: 'orders#confirm_out', on: :member
    end
    resources :supplies
  end

  # Получить html-код кнопки "Добавить запись"
  get 'link/new_record', to: 'application#link_to_new_record'

  # Получить список пользователей указанного отдела
  get 'user_isses/users_from_division/:division', to: 'user_isses#users_from_division'

  mount ActionCable.server, at: '/cable'
end
