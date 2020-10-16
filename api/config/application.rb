require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'active_storage/engine'
require 'csv'

require 'devise'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsBootstrap
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'America/Argentina/Buenos_Aires'
    config.active_record.default_timezone = :local

    if Rails.application.secrets.email_recipients_interceptors.present?
      Mail.register_interceptor RecipientInterceptor.new(
        Rails.application.secrets.email_recipients_interceptors,
        subject_prefix: '[INTERCEPTOR]'
      )
    end

    # Required middlewares for Rails Admin
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Session::CookieStore, key: "_rails-bootstrap_session"

    # Autoloading custom validators
    Dir[Rails.root.join('app', 'validators').to_s]

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = false

    # Jobs adapter
    config.active_job.queue_adapter = :sidekiq

    # Mailer Config
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      user_name: Rails.application.secrets.mailer_username,
      password: Rails.application.secrets.mailer_password,
      address: Rails.application.secrets.mailer_address,
      domain: Rails.application.secrets.mailer_domain,
      port: Rails.application.secrets.mailer_port,
      authentication: :plain,
      enable_starttls_auto: true,
      openssl_verify_mode: 'none',
      ssl: true,
      tls: true
    }

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "#{ENV.fetch('CORS_PERMITTED_ORIGIN', '*')}"
        resource "#{ENV.fetch('CORS_PERMITTED_ORIGIN', '*')}", headers: :any, methods: [:get, :post, :options]
      end
    end
  end
end
