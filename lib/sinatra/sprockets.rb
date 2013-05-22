require 'sprockets'
require 'sprockets-helpers'

require 'version'
require 'server'
require 'helpers'

module Sinatra
  module Sprockets
    class << self
      attr_accessor :sprockets, 
        :assets_prefix, :assets_path, :assets_host, :assets_precompile,
        :assets_css_compressor, :assets_js_compressor, :assets_manifest_file

      def registered(app)
        # Create a Sprockets environment
        sprockets ||= Sprockets::Environment.new(app.root)
        app.set :sprockets, sprockets
        # Configure
        app.set_default :assets_prefix,     '/assets'
        app.set_default :assets_path,       [assets_prefix]
        app.set_default :assets_precompile, %w(application.js application.css)
        app.set_default :assets_host,       ''
        # Compressors
        app.set_default :assets_css_compressor, :none
        app.set_default :assets_js_compressor,  :none
        # Set the manifest file path
        app.set_default :assets_manifest_file, 
          File.join(app.public_folder, assets_prefix, "manifset.json")
        
        # Append all paths
        assets_path.each do |path|
          sprockets.append_path File.join(app.root, path)
        end

        # Configure Sprockets::Helpers
        Sprockets::Helpers.configure do |config|
          config.environment = app.sprockets
          config.manifest    = Sprockets::Manifest.new(app.sprockets, app.assets_manifest_file)
          config.prefix      = app.assets_prefix
          config.public_path = app.public_folder
          config.digest      = true
        end
        # Add my helpers
        app.helpers Helpers

        # Register asset pipeline middleware so we don't need to route on .ru
        app.use Server, app.sprockets, %r(#{assets_prefix})
        
        # Configure compression on production
        app.configure :production do
          app.sprockets.css_compressor = app.assets_css_compressor unless app.assets_css_compressor == :none
          app.sprockets.js_compressor  = app.assets_js_compressor  unless app.assets_js_compressor  == :none
        end
      end
    end

    def set_default(key, default_value)
      self.set(key, default_value) unless self.respond_to? key
    end
  end
  # Register for classic style apps
  register Sprockets
end