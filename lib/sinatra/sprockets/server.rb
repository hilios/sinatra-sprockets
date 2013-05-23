module Sinatra
  module Sprockets
    # http://stackoverflow.com/a/10679994
    class Server
      attr_reader :app, :engine, :path_prefix

      def initialize(app, engine, path_prefix, &block)
        @app = app
        @engine = engine
        @path_prefix = path_prefix
        yield engine if block_given?
      end

      def call(env)
        path = env["PATH_INFO"]
        if path =~ path_prefix and not engine.nil?
          env["PATH_INFO"].sub!(path_prefix, '')
          engine.call(env)
        else
          app.call(env)
        end
      ensure
        env["PATH_INFO"] = path
      end
    end
  end
end