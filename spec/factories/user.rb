FactoryGirl.define do
  factory :user do
    id_tn 110
    tn 101_101
    phone '50-50'
    division 714
    email nil
    login 'TestLK'
    fullname 'Тест Личного кабинета'
    password 'xxxx1234'
    association :role, factory: :admin_role
  end

  factory :bayburin_user, class: User do
    id_tn 12880
    tn 17664
    phone '50-32'
    division 714
    email 'bayburin@iss-reshetnev.ru'
    login 'BayburinRF'
    fullname 'Байбурин Равиль Фаильевич'
    association :role, factory: :lk_user_role
  end
end
