FactoryBot.define do
  factory :user do
    id_tn { 110 }
    tn { 101_101 }
    phone { '50-50' }
    division { 714 }
    email { nil }
    login { 'TestLK' }
    fullname { 'Тест Личного кабинета' }
    password { 'xxxx1234' }

    after(:build) do |user, ev|
      unless ev.role
        user.role = Role.find_by(name: :admin) || create(:admin_role)
      end
    end
  end

  factory :bayburin_user, class: User do
    id_tn { 12_880 }
    tn { 17_664 }
    phone { '50-32' }
    division { 714 }
    email { 'bayburin@iss-reshetnev.ru' }
    login { 'BayburinRF' }
    fullname { 'Байбурин Равиль Фаильевич' }

    after(:build) do |user, ev|
      unless ev.role
        user.role ||= Role.find_by(name: :lk_user) || create(:lk_user_role)
      end
    end
  end

  factory :kucherenko_user, class: User do
    id_tn { 5336 }
    tn { 24_079 }
    phone { '39-45' }
    division { 714 }
    email { 'v714@iss-reshetnev.ru' }
    login { 'KucherenkoVN' }
    fullname { 'Кучеренко Виктор Николаевич' }

    after(:build) do |user, ev|
      unless ev.role
        user.role = Role.find_by(name: :manager) || create(:manager_role)
      end
    end
  end

  factory :tyulyakova_user, class: User do
    id_tn { 9906 }
    tn { 24_108 }
    phone { '59-57' }
    division { 714 }
    email { 'tulq@iss-reshetnev.ru' }
    login { 'TyulyakovaTA' }
    fullname { 'Тюлякова Татьяна Анатольевна' }

    after(:build) do |user, ev|
      unless ev.role
        user.role = Role.find_by(name: :read_only_role) || create(:read_only_role)
      end
    end
  end

  factory :shatunova_user, class: User do
    id_tn { 10_872 }
    tn { 3996 }
    phone { '48-70' }
    division { 714 }
    email { 'viola@iss-reshetnev.ru' }
    login { 'ShatunovaOL' } 
    fullname { 'Шатунова Ольга Леонидовна' }

    after(:build) do |user, ev|
      unless ev.role
        user.role = Role.find_by(name: :worker) || create(:worker_role)
      end
    end
  end

  factory :invalid_user, class: User do
    id_tn { 111_222 }
    tn { 123_321 }
  end
end
