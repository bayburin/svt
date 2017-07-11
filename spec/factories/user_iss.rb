FactoryGirl.define do
  factory :user_iss do
    tn 101_101
    dept 714
    fio 'Тест Личного кабинета'
    room '2-40'
    tel '54-26'
    wname ''
    email ''
    comment ''
    duty 'Тестер личного кабинета'
    status ''
    datereg 5.years.ago
    duty_code 0
    fio_initials 'Тест Л.к.'
    category 0
    id_tn 110
    dept_kadr 0
    decret false
  end

  factory :bayburin_user_iss, class: UserIss do
    tn 17_664
    dept 714
    fio 'Байбурин Равиль Фаильевич'
    room '3а-321а'
    tel '50-32'
    wname ''
    email ''
    comment ''
    duty 'инженер-программист 3 категории'
    status 'changed'
    datereg 5.years.ago
    duty_code 0
    fio_initials 'Байбурин Р.Ф.'
    category 4
    id_tn 12880
    dept_kadr 714
    decret false
  end
end
