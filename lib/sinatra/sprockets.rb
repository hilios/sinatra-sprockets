require 'sprockets'

Dir[File.join(File.expand_path(File.dirname __FILE__), "sprockets/**/*.rb")].each { |file| require file }

module Sinatra
  module Sprockets
    class << self
      attr_accessor :sprockets

      def registered(app)
        return if app.root.nil?
        # Sprockets configuration
        app.set_default :assets_prefix,     '/assets'
        app.set_default :assets_path,       %w(assets)
        app.set_default :assets_precompile, %w(application.js application.css 
          *.css *.js *.gif *.jpg *.png *.svg *.ttf *.otf *.eot *.woff)
        # Compressors
        app.set_default :assets_css_compressor, :none
        app.set_default :assets_js_compressor,  :none
        # Helpers options
        app.set_default :assets_host,       ''
        app.set_default :assets_protocol,   :relative
        app.set_default :assets_digest,     true
        app.set_default :assets_expand,     false
        app.set_default :assets_debug,      false
        # Set the manifest file path
        app.set_default :assets_manifest_file,
          File.join(app.public_folder, app.assets_prefix)
        
        app.configure do
          # Create a Sprockets environment
          sprockets ||= ::Sprockets::Environment.new(app.root)
          app.set :sprockets, sprockets
          # Append all paths to Sprockets
          app.assets_path.each do |path|
            path = File.join(app.root, path) unless path =~ /^\//
            sprockets.append_path path
          end
          # Configure Sprockets::Helpers
          ::Sprockets::Helpers.configure do |config|
            config.environment = app.sprockets
            config.prefix      = app.assets_prefix
            config.public_path = app.public_folder
            config.manifest    = ::Sprockets::Manifest.new(app.sprockets, 
              app.assets_manifest_file)
            # Optionals
            config.asset_host  = app.assets_host
            config.protocol    = app.assets_protocol
            config.digest      = app.assets_digest
            config.expand      = app.assets_expand
            # Debug mode automatically sets
            # expand = true, digest = false, manifest = false
            config.debug       = app.assets_debug
          end
          # Add my helpers
          app.helpers Helpers
        end

        app.configure :development do
          # Register asset pipeline middleware so we don't need to route on .ru
          app.use Server, app.sprockets, %r(#{app.assets_prefix})
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

  register Sprockets
end