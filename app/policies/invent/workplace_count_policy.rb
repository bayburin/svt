module Invent
  class WorkplaceCountPolicy < ApplicationPolicy
    # Если роль 'lk_user': есть ли у пользователя доступ к указанному отделу.
    # Иначе: доступ есть.
    def generate_pdf?
      if @user.has_role? :lk_user
        division_access?
      else
        true
      end
    end

    private

    # Есть ли доступ на работу с указанным отделом.
    def division_access?
      @user.workplace_counts.pluck(:division).any? { |division| division == @record.division }
    end
  end
end