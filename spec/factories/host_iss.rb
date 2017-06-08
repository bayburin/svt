FactoryGirl.define do
  factory :host_iss, class: Hash do
    # Здесь показаны не все параметры таблицы 'hosts'.
    id '764196'
    ip '10.1.8.26'
    tn 17664
    user 'Байбурин Равиль Фаильевич'
    name 'ravil'
    division '714'
    flag_set 'inet_access'

    initialize_with { attributes }
  end
end