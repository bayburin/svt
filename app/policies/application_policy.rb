class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # Пользователям с ролью lk_user доступ запрещен
  def authorization?
    not_for_lk_user
  end

  def admin?
    user.role? :admin
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  protected

  def for_manager
    return true if admin?

    user.role? :manager
  end

  def for_worker
    return true if admin?

    user.one_of_roles? :manager, :worker
  end

  def not_for_lk_user
    !user.role? :lk_user
  end
end
