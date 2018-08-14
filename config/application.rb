require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Inv
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    config.assets.enabled = true

    config.force_ssl = true
    config.ssl_options = { domain: 'iss-reshetnev.ru' }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Krasnoyarsk'
    config.active_record.default_timezone = :local
    config.i18n.default_locale = :ru

    # Загрузка всех файлов из
    config.autoload_paths << Rails.root.join('app', 'services').to_s
    config.autoload_paths << Rails.root.join('app', 'modules').to_s
    config.autoload_paths << Rails.root.join('app', 'states').to_s
    config.autoload_paths << Rails.root.join('lib', 'validators').to_s

    # Provides support for Cross-Origin Resource Sharing (CORS)
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'https://lk-3-dev.iss-reshetnev.ru', 'https://lk-3-dev.npopm``.ru',
                'https://lk-test-3.iss-reshetnev.ru', 'https://lk-test-3.npopm.ru',
                'https://lk.iss-reshetnev.ru', 'https://lk.npopm.ru', 'http://koza'
        resource '/invent/lk_invents/svt_access*', headers: :any, methods: [:get]
        resource '/invent/lk_invents/init_properties*', headers: :any, methods: [:get]
        resource '/invent/lk_invents/show_division_data*', headers: :any, methods: [:get]
        resource '/invent/lk_invents/pc_config_from_audit*', headers: :any, methods: [:get]
        resource '/invent/lk_invents/pc_config_from_user*', headers: :any, methods: [:post]
        resource '/invent/lk_invents/create_workplace*', headers: :any, methods: [:post]
        resource '/invent/lk_invents/edit_workplace*', headers: :any, methods: [:get]
        resource '/invent/lk_invents/update_workplace*', headers: :any, methods: [:patch]
        resource '/invent/lk_invents/destroy_workplace*', headers: :any, methods: [:delete]
        resource '/invent/lk_invents/generate_pdf*', headers: :any, methods: [:get]
        resource '/invent/lk_invents/get_pc_script*', headers: :any, methods: [:get]
        resource '/invent/lk_invents/existing_item*', headers: :any, methods: [:get]
      end
    end

    config.generators do |g|
      g.template_engine :haml
      g.test_framework :rspec,
                       fixtures: true,
                       view_spec: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false,
                       controller_spec: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    config.action_cable.url = "wss://#{ENV['APPNAME']}.iss-reshetnev.ru/cable"
  end
end
