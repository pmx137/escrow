require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require *Rails.groups(:assets => %w(development test))
end

module App
  class Application < Rails::Application
    config.i18n.default_locale = :pl
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.assets.enabled = true
    config.assets.version = '1.0'
    #config.generators do |g|
    #  g.test_framework :rspec
    #end
  end
end
Haml::Template.options[:format] = :html5