require 'sprockets'

Dir[File.join(File.expand_path(File.dirname __FILE__), "sprockets/**/*.rb")].each { |file| require file }

module Sinatra
  module Sprockets
    class << self
      attr_accessor :sprockets

      def registered(app)
        # Create a Sprockets environment
        return if app.root.nil?
        sprockets ||= ::Sprockets::Environment.new(app.root)
        app.set :sprockets, sprockets
        # Configure
        app.set_default :assets_prefix,     '/assets'
        app.set_default :assets_path,       %w(assets)
        app.set_default :assets_precompile, %w(application.js application.css 
          *.css *.js *.gif *.jpg *.png *.svg *.ttf *.otf *.eot *.woff)
        app.set_default :assets_host,       ''
        app.set_default :assets_digest,     true
        # Compressors
        app.set_default :assets_css_compressor, :none
        app.set_default :assets_js_compressor,  :none
        # Set the manifest file path
        app.set_default :assets_manifest_file,
          File.join(app.public_folder, app.assets_prefix)
        
        # Append all paths
        app.assets_path.each do |path|
          path = File.join(app.root, path) unless path =~ /^\//
          sprockets.append_path path
        end

        app.configure do
          # Configure Sprockets::Helpers
          ::Sprockets::Helpers.configure do |config|
            config.environment = app.sprockets
            config.manifest    = ::Sprockets::Manifest.new(app.sprockets, 
              app.assets_manifest_file)
            config.prefix      = app.assets_prefix
            config.public_path = app.public_folder
            config.digest      = app.assets_digest
            # Force to debug mode in development mode
            # Debug mode automatically sets
            # expand = true, digest = false, manifest = false
            config.debug       = true if app.development?
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