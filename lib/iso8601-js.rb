require 'iso8601-js/version'

module ISO8601JS
  ASSETS_PATH = File.expand_path('..', __FILE__).freeze

  def self.assets_path
    ASSETS_PATH
  end


  # Automatic initialization if used with Rails 3.1+
  if defined? ::Rails::Railtie
    class Railtie < ::Rails::Railtie
      initializer 'iso8601-js', :after => 'sprockets.environment' do |app|
        app.assets.append_path(ISO8601JS.assets_path) if app.assets
      end
    end
  end
end
