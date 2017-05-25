# require_relative './omniauth_macros'

module ControllerMacros
  include OmniauthMacros

  def sign_in_user(**params)
    before do
      @user = create(:user, params)
      login_with_omniauth

      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:open_id_lk]

      sign_in @user
    end
  end

  def sign_in_through_lk_user
    before do
      @lk_user = create(:lk_user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @lk_user
    end
  end
end
