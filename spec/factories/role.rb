FactoryBot.define do
  factory :admin_role, class: Role do
    name 'admin'
    short_description 'Администратор'
    long_description 'Полные права доступа на все ресурсы'
  end

  factory :lk_user_role, class: Role do
    name 'lk_user'
    short_description 'Пользотель ЛК'
    long_description 'Пользователь ЛК, от которого пользователь ЛК входит в систему'
  end

  factory :manager_role, class: Role do
    name 'manager'
    short_description 'Менеджер'
    long_description 'Пользователь с расширенными правами'
  end
end
