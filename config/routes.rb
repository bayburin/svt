Rails.application.routes.draw do
  require 'sidekiq/web'

  devise_for :users

  devise_scope :user do
    get 'users/callbacks/registration_user', to: 'users/callbacks#registration_user'
    get 'users/callbacks/authorize_user', to: 'users/callbacks#authorize_user'

    root 'invent/workplaces#index'
  end

  authenticate :user, lambda { |u| u.role? :admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :users

  # Инвентаризация
  namespace :invent do
    # Отделы
    resources :workplace_counts, param: :workplace_count_id do #, except: :edit
      collection do
        # Сформировать файл со списком РМ и их составом
        get 'generate_pdf/:division', to: 'workplace_counts#generate_pdf', constraints: { division: /\d+/ }
        # post 'create_list', to: 'workplace_counts#create_list'
      end
    end
    # Рабочие места
    resources :workplaces, except: [:update], param: :workplace_id do
      collection do
        # Вывести все РМ списком
        get 'list_wp', to: 'workplaces#list_wp'
        # Подтвердить/отклонить конфигурацию РМ
        put 'confirm', to: 'workplaces#confirm'
        # Скачать скрипт для генерации файла конфигурации ПК
        get 'pc_script', to: 'workplaces#send_pc_script'
        # Получить id категории для комнаты
        get 'category_for_room', to: 'workplaces#category_for_room'
      end

      put 'update', as: 'update', on: :collection
      delete 'hard_destroy', to: 'workplaces#hard_destroy', on: :member
    end

    # Скачивание файлов, прикрепленных к рабочему месту
    # прямой путь используется в /services/invent/workplaces/list_wp.rb
    get 'attachments/download/:id', to: 'attachments#download', as: 'attachments/download'

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
    # Показать данные по указанной технике
    get 'lk_invents/invent_item', to: 'lk_invents#invent_item'

    resources :items, except: [:new, :create], param: :item_id do
      collection do
        get 'avaliable/:type_id', to: 'items#avaliable', constraints: { type_id: /\d+/ }
        get 'busy', to: 'items#busy'
        # Получить данные о системном блоке из аудита
        get 'pc_config_from_audit/:invent_num', to: 'items#pc_config_from_audit', constraints: { invent_num: /.*/ }
        # Расшифровать файл конфигурации ПК, загруженный пользователем.
        post 'pc_config_from_user', to: 'items#pc_config_from_user'
        # Отправить технику на склад
        post 'to_stock', to: 'items#to_stock'
        # Списать технику
        post 'to_write_off', to: 'items#to_write_off'
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
    # Получить информацию о всех расположениях
    get 'locations/load_locations', to: 'locations#load_locations'

    get 'locations/load_rooms/:building_id', to: 'locations#rooms_for_building'

    resources :items
    # Разделить одну технику на множество с разным расположением на складе
    put 'items/:id/split', to: 'items#split'
    
    resources :orders, only: [:new, :edit, :destroy] do
      get 'in', to: 'orders#index_in', on: :collection
      get 'out', to: 'orders#index_out', on: :collection
      get 'write_off', to: 'orders#index_write_off', on: :collection
      get 'archive', to: 'orders#archive', on: :collection
      get 'print', to: 'print', on: :member
      post 'create_in', to: 'orders#create_in', on: :collection
      post 'create_out', to: 'orders#create_out', on: :collection
      post 'create_write_off', to: 'orders#create_write_off', on: :collection
      post 'execute_in', to: 'orders#execute_in', on: :member
      post 'execute_out', to: 'orders#execute_out', on: :member
      post 'execute_write_off', to: 'orders#execute_write_off', on: :member
      post 'prepare_to_deliver', to: 'orders#prepare_to_deliver', on: :member
      put 'update_in', to: 'orders#update_in', on: :member
      put 'update_out', to: 'orders#update_out', on: :member
      put 'update_write_off', to: 'orders#update_write_off', on: :member
      put 'confirm', to: 'orders#confirm', on: :member
    end
    resources :supplies
  end

  # Получить html-код кнопки "Добавить запись"
  get 'link/new_record', to: 'application#link_to_new_record'

  resources :user_isses, only: :index do
    # Получить список пользователей указанного отдела
    get 'users_from_division/:division', to: 'user_isses#users_from_division', on: :collection
    # Получить список техники привязанной за пользователем
    get :items, to: :items
  end

  resource :statistics, only: :show

  namespace :api do
    namespace :v1 do
      namespace :invent do
        resources :items, only: :index 
      end
    end
  end

  mount ActionCable.server, at: '/cable'
end
