require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_view/railtie"
# require "sprockets/railtie"

# require "rails/test_unit/railtie"

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AfterParty
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil
    
    config.generators do |g|
      g.assets false
      g.helper false
      g.template_engine = :slim
      g.test_framework :rspec, view_specs: false, routing_specs: false
      g.stylesheets false
      g.javascripts false
    end
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'
    
    config.active_record.raise_in_transactional_callbacks = true
    # Auto load in under lib dir.
    config.enable_dependency_loading = true
    config.autoload_paths += Dir["#{config.root}/lib/**/*"]
    # Auto load in under domains dir.
    config.autoload_paths += Dir["#{config.root}/app/**/**/*"]
    config.autoload_paths += Dir["#{config.root}/app/**/**/**/*"]

    def environment_type
      if Rails.env.production? && ENV['STAGE'] != 'staging'
        'production'
      elsif Rails.env.production? && ENV['STAGE'] == 'staging'
        'staging'
      else
        users = User.where.not(email: nil)
        return 'development' if users.empty?
        "development_#{users.last.email.tr('@', '')}"
      end
    end


  end
end
