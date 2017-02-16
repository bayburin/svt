Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'work_places#index'

  # Инвентаризация
  resources :workplaces, param: :workplace_id

  # Отделы
  resources :count_workplaces, param: :count_workplace_id, except: :edit do
    get 'link/new_record',    to: 'count_workplaces#link_to_new_record',  on: :collection
  end

  # Запросы с ЛК
  # Инициализация
  get 'lk_invents/init/:tn', to: 'lk_invents#init', constraints: { tn: /\d+/ }
  # Получить данные по выбранном отделу (список РМ, макс. число, список работников отдела)
  get 'lk_invents/show_division_data/:division', to: 'lk_invents#show_division_data', constraints: { division: /\d+/ }

  # Эталоны
  resources :system_units
end
