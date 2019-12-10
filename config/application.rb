require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GagaTown
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.time_zone = 'Asia/Tokyo'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators do |g|
      g.test_framework :rspec,
                         view_specs: true,
                         helper_specs: false,
                         routing_specs: false,
                         controller_specs: true,
                         request_specs: true,
                         feature_spec: true,
                         model_spec: true
       g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

  end
end
