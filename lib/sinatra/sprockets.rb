require 'sprockets'
require 'sprockets/version'
require 'sprockets/server'
require 'sprockets/helpers'

module Sinatra
  module Sprockets
    class << self
      attr_accessor :sprockets

      def registered(app)
        # Create a Sprockets environment
        sprockets ||= ::Sprockets::Environment.new(app.root)
        app.set :sprockets, sprockets
        # Configure
        app.set_default :assets_prefix,     '/assets'
        app.set_default :assets_path,       [app.assets_prefix]
        app.set_default :assets_precompile, %w(application.js 
          application.css)
        app.set_default :assets_host,       ''
        # Compressors
        app.set_default :assets_css_compressor, :none
        app.set_default :assets_js_compressor,  :none
        # Set the manifest file path
        app.set_default :assets_manifest_file, 
          File.join(app.public_folder, app.assets_prefix, "manifset.json")
        
        # Append all paths
        app.assets_path.each do |path|
          sprockets.append_path File.join(app.root, path)
        end

        # Configure Sprockets::Helpers
        ::Sprockets::Helpers.configure do |config|
          config.environment = app.sprockets
          config.manifest    = ::Sprockets::Manifest.new(app.sprockets, 
            app.assets_manifest_file)
          config.prefix      = app.assets_prefix
          config.public_path = app.public_folder
          config.digest      = true
        end
        # Add my helpers
        app.helpers do
          include Helpers
        end

        app.configure :development do
          # Register asset pipeline middleware so we don't need to route on .ru
          app.use Server, app.sprockets, %r(#{assets_prefix})
        end
        
        # Configure compression on production
        app.configure :production do
          # Set the CSS compressor
          unless app.assets_css_compressor == :none
            app.sprockets.css_compressor = app.assets_css_compressor
          end
          # Set the JS compressor
          unless app.assets_js_compressor  == :none
            app.sprockets.js_compressor  = app.assets_js_compressor
          end
        end
      end
    end

    def set_default(key, default_value)
      self.set(key, default_value) unless self.respond_to? key
    end
  end
end