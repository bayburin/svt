FactoryGirl.define do
  factory :user do
    tn 17_664
    info 'Байбурин Равиль Фаильевич'
    association :role, factory: :admin_role
  end

  factory :lk_user, class: User do
    tn 999_999
    info 'Пользователь ЛК'
    association :role, factory: :lk_user_role
  end
end
