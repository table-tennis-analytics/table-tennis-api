require File.expand_path('../boot', __FILE__)

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TableTennisApi
  class Application < Rails::Application
    config.eager_load_paths << config.root.join('lib')

    config.active_record.raise_in_transactional_callbacks = true
    config.time_zone = 'Vilnius'

    config.i18n.available_locales = [:en]
    config.i18n.default_locale = :en

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options, :patch, :put, :delete]
      end
    end
  end
end
