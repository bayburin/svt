FactoryGirl.define do
  factory :user do
    tn 101_101
    id_tn 110
    division 714
    email nil
    login 'TestLK'
    fullname 'Тест Личного кабинета'
    password 'xxxx1234'
    association :role, factory: :admin_role
  end

  factory :lk_user, class: User do
    tn 999_999
    fullname 'Пользователь ЛК'
    association :role, factory: :lk_user_role
  end
end
