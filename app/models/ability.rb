class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :lk_user
      can :manage, :lk_invent
      # can :init_properties, :lk_invent
      # can :show_division_data, :lk_invent, {  }
      # can :pc_config_from_audit, :lk_invent
      # can :create_workplace, :lk_invent
    else
      cannot :manage, :all
    end
  end
end
