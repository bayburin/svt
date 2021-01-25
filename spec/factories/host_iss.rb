FactoryBot.define do
  factory :host_iss, class: Hash do
    # Здесь показаны не все параметры таблицы 'hosts'.
    id { '768707' }
    ip { '10.1.8.50' }
    mac { '9c5c8e7a6fa1' }
    tn { 3737 }
    user { 'Блинова Ирина Рудольфовна' }
    division { '714' }
    flag_set { 'inet_access,ad_member,auto_auth' }

    initialize_with { attributes }
  end
end
