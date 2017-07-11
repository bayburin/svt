module OmniauthMacros
  def login_with_omniauth(user = nil)
    OmniAuth.config.mock_auth[:open_id_lk] = OmniAuth::AuthHash.new(
      provider: 'open_id_lk',
      uid: '12345',
      info: OmniAuth::AuthHash::InfoHash.new((user || @user).as_json),
      credentials: OmniAuth::AuthHash.new(
        token: 'mock_token',
        secret: 'mock_secret'
      )
    )
  end
end