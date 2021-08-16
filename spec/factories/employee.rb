FactoryBot.define do
  factory :emp_empty, class: Hash do
    nil
  end

  factory :emp_drag, class: Hash do
    positionId { 2273 }
    id { 2709 }
    fullName { 'Дрянных Алексей Геннадьевич' }
    personnelNo { 24_125 }
    departmentId { 10_134 }
    departmentForAccounting { 714 }
    departmentForDocuments { '714' }
    deptForDocs { 714 }
    professionCode { 24_907 }
    professionForAccounting { 'НАЧАЛЬНИК СЕКТОРА' }
    professionForDocuments { 'НАЧАЛЬНИК СЕКТОРА РЕМОНТА ПЕРСОНАЛЬНЫХ КОМПЬЮТЕРОВ' }
    phone { ['24-80'] }
    mobilePhone { [] }
    email { ['drag@iss-reshetnev.ru'] }
    phoneText { '24-80' }
    emailText { 'drag@iss-reshetnev.ru' }
    position { '2-237' }

    initialize_with { attributes.stringify_keys }
  end

  factory :emp_agureev, class: Hash do
    id { 72 }
    fullName { 'Агуреев Александр Викторович' }
    personnelNo { 24_031 }
    departmentId { 10_134 }
    departmentForAccounting { 714 }
    professionForAccounting { 'ВЕДУЩИЙ ИНЖЕНЕР-ЭЛЕКТРОНИК' }
    professionForDocuments { 'ВЕДУЩИЙ ИНЖЕНЕР-ЭЛЕКТРОНИК' }

    initialize_with { attributes.stringify_keys }
  end

  factory :emp_kucherenko, class: Hash do
    id { 5336 }
    fullName { 'Кучеренко Виктор Николаевич' }
    personnelNo { 24_079 }
    departmentId { 10_134 }
    departmentForAccounting { 714 }
    professionForAccounting { 'ВЕДУЩИЙ ИНЖЕНЕР' }
    professionForDocuments { 'ВЕДУЩИЙ ИНЖЕНЕР' }
    phoneText { '39-45' }

    initialize_with { attributes.stringify_keys }
  end

  factory :emp_korjov, class: Hash do
    id { 15_907 }
    fullName { 'Коржов Игорь Николаевич' }
    personnelNo { 12_321 }
    departmentId { 10_129 }
    departmentForAccounting { 715 }
    professionForAccounting { 'МАСТЕР' }
    professionForDocuments { 'МАСТЕР' }
    mobilePhone { [] }
    email { [] }

    initialize_with { attributes.stringify_keys }
  end

  factory :emp_bartuzanovaan, class: Hash do
    lastName { 'БАРТУЗАНОВА' }
    firstName { 'АНЖЕЛИКА' }
    middleName { 'НИКОЛАЕВНА' }
    positionId { 7790 }
    id { 26_840 }
    sex { 'Ж' }
    fullName { 'Бартузанова Анжелика Николаевна' }
    personnelNo { 21_056 }
    departmentId { 10_134 }
    departmentForAccounting { 714 }
    departmentForDocuments { '714' }
    deptForDocs { '714' }
    professionCode { 22_446 }
    professionForAccounting { 'ИНЖЕНЕР' }
    professionForDocuments { 'ИНЖЕНЕР' }
    inVacation { false }
    employeeStatusId { 0 }
    employeeStatus { 'Основной' }
    struct { '7141' }
    computerName { 'n769566' }
    phone { ['84-29'] }
    mobilePhone { [] }
    email { ['bartuzanovaan@iss-reshetnev.ru'] }
    phoneText { '84-29' }
    emailText { 'bartuzanovaan@iss-reshetnev.ru' }
    position { '3А-320' }
    vacation { 'Декретный отпуск' }
    vacationFrom { '2222-11-11' }
    vacationTo { '2222-02-22' }

    initialize_with { attributes.stringify_keys }
  end

  factory :emp_bayburin, class: Hash do
    lastName { 'БАЙБУРИН' }
    firstName { 'РАВИЛЬ' }
    middleName { 'ФАИЛЬЕВИЧ' }
    positionId { 6295 }
    id { 12_880 }
    sex { 'М' }
    fullName { 'Байбурин Равиль Фаильевич' }
    personnelNo { 17_664 }
    departmentId { 10_134 }
    departmentForAccounting { 714 }
    departmentForDocuments { '714' }
    deptForDocs { '714' }
    professionCode { 228_242 }
    professionForAccounting { 'ИНЖЕНЕР-ПРОГРАММИСТ 2 КАТЕГОРИИ' }
    professionForDocuments { 'ИНЖЕНЕР-ПРОГРАММИСТ 2 КАТЕГОРИИ' }
    inVacation { false }
    employeeStatusId { 0 }
    employeeStatus { 'Основной' }
    struct { '7141' }
    computerName { '.........' }
    phone { ['84-29'] }
    mobilePhone { [] }
    email { ['bayburin@iss-reshetnev.ru'] }
    phoneText { '84-29' }
    emailText { 'bayburin@iss-reshetnev.ru' }
    position { '3а-321а' }

    initialize_with { attributes.stringify_keys }
  end
end
