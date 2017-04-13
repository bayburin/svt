FactoryGirl.define do
  factory :user do
    tn    17664
    info  'Байбурин Равиль Фаильевич'
    association :role, factory: :admin_role
  end

  factory :lk_user, class: User do
    tn    999999
    info  'Пользователь ЛК'
    association :role, factory: :lk_user_role
  end
end