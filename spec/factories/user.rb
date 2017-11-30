FactoryBot.define do
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
    id_tn 12_880
    tn 17_664
    phone '50-32'
    division 714
    email 'bayburin@iss-reshetnev.ru'
    login 'BayburinRF'
    fullname 'Байбурин Равиль Фаильевич'
    association :role, factory: :lk_user_role
  end

  factory :kucherenko_user, class: User do
    id_tn 5336
    tn 24_079
    phone '39-45'
    division 714
    email 'v714@iss-reshetnev.ru'
    login 'KucherenkoVN'
    fullname 'Кучеренко Виктор Николаевич'
    association :role, factory: :manager_role
  end

  factory :invalid_user, class: User do
    id_tn 111_222
    tn 123_321
  end
end
