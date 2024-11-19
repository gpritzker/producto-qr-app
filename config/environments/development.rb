Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is reloaded on every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Disable server timing
  config.server_timing = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  config.active_storage.service = :local


  config.assets.compile
  config.assets.debug

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true
  config.i18n.default_locale = :es
  config.i18n.fallbacks = [:en]

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true
end