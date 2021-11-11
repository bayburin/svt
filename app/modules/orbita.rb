# Запросы в orbita-center
module Orbita
  # Добавление события
  def self.add_event(id, user_id_tn, type, params = nil, files = nil)
    token if Rails.cache.read('token_orbita').blank?

    data = {}
    data['integration_id'] = id
    data['id_tn'] = user_id_tn
    data['event_type'] = type
    data['payload'] = params if params.present?
    data['files'] = files if files.present?

    request = RestClient::Request.new(
      method: :post,
      verify_ssl: false,
      url: ENV['ORBITA_EVENTS_URI'],
      headers: {
        'Authorization' => "Bearer #{Rails.cache.read('token_orbita')}",
        'Accept' => 'application/json'
      },
      payload: data
    )
    Rails.logger.info "data #{data}".cyan

    # 'Content-Type' => 'application/rtf'
    # Rails.logger.info "Response code #{request.inspect}".green
    # true

    response = request.execute { |resp| resp }
    Rails.logger.info "Response code #{response.code}".green
    Rails.logger.info "Response #{response.body}".red

    case response.code
    when 200
      # return true if JSON.parse(response)['message'] == 'Событие обработано'
      true
    else
      Rails.logger.info "orbita: #{JSON.parse(response)['error']}".red
      false
    end

    # (0..1).each do |_|
    #   new_token if Rails.cache.read('token_orbita').blank?
    #   response = user_where(params)

    #   return response if response

    #   Rails.cache.delete('token_hr')
    # end
    # []
  end

  def self.token
    request = RestClient::Request.new(
      method: :post,
      verify_ssl: false,
      url: ENV['ORBITA_TOKEN_URI'],
      payload: {
        client_id: ENV['ORBITA_CLIENT_ID'],
        client_secret: ENV['ORBITA_SECRET'],
        grant_type: 'client_credentials'
      }
    )

    response = request.execute { |resp| resp }
    Rails.logger.info "Response #{response}".red

    case response.code
    when 200
      Rails.cache.write('token_orbita', JSON.parse(response)['access_token'])
      true
    else
      false
    end
  end
end
