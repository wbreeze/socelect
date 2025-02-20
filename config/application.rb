require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Socelect
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # content security policy; preferred over the DSL
    config.action_dispatch.default_headers['X-Content-Security_Policy'] =
      <<~POLICY.gsub("\n", "\s")
      default-src 'none';
      image-src 'self';
      style-src-elem 'self';
      script-src-elem 'self';
      report-to csp-reporting-endpoint
      POLICY

    config.action_dispatch.default_headers['Strict-Transport-Security'] =
      "max-age=3600"

    # Queuing backend for Active Job
    config.active_job.queue_adapter = :delayed_job

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
