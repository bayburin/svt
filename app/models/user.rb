class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :timeoutable, :omniauthable,
         omniauth_providers: [:open_id_lk, :check_lk_auth], authentication_keys: [:login]

  belongs_to :role

  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["tn = :value", { :value => login }]).first
    elsif conditions.has_key?(:tn)
      where(conditions.to_hash).first
    end
  end

  # Проверка наличия указанной роли у пользователя
  # role_sym - символ имени роли
  def has_role?(role_sym)
    role.name.to_sym == role_sym
  end

  protected

  def password_required?
    false
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end