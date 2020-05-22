module Warehouse
  class LocationPolicy < Warehouse::ApplicationPolicy
    def ctrl_access?
      not_for_lk_user
    end
  end
end
