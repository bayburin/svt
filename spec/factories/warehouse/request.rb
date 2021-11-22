module Warehouse
  FactoryBot.define do
    factory :request_category_one, class: Request do
      category { 'office_equipment' }
      user_tn { build(:emp_kucherenko)['personnelNo'] }
      user_id_tn { build(:emp_kucherenko)['id'] }
      user_fio { build(:emp_kucherenko)['fullName'] }
      user_dept { build(:emp_kucherenko)['departmentForAccounting'] }
      user_phone { build(:emp_kucherenko)['phoneText'] }
      number_orbita { 123 }
      number_lk { 321 }
      executor_fio { build(:emp_korjov)['fullName'] }
      executor_tn { build(:emp_korjov)['personnelNo'] }
      comment { nil }
      status { 'new' }

      request_items { [create(:request_item)] }
    end

    factory :request_category_two, class: Request do
      category { 'printing' }
      user_tn { build(:emp_kucherenko)['personnelNo'] }
      user_id_tn { build(:emp_kucherenko)['id'] }
      user_fio { build(:emp_kucherenko)['fullName'] }
      user_dept { build(:emp_kucherenko)['departmentForAccounting'] }
      user_phone { build(:emp_kucherenko)['phoneText'] }
      number_orbita { 123 }
      number_lk { 321 }
      executor_fio { build(:emp_korjov)['fullName'] }
      executor_tn { build(:emp_korjov)['personnelNo'] }
      comment { nil }
      status { 'new' }
    end
  end
end
