module Invent
  class ItemPolicy < ApplicationPolicy
    def ctrl_access?
      not_for_lk_user
    end

    def destroy?
      for_worker
    end
  end
end