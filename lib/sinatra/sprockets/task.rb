require 'rake'
require 'rake/tasklib'
require 'rake/sprocketstask'

module Sinatra
  module Sprockets
    class Task < Rake::SprocketsTask
      # Just create a wrapper for the Sprockets Task
      def initialize(app)
        super(:precompile)
        @output       = File.join(app.public_folder, app.assets_prefix)
        @assets       = app.assets_precompile
        @environment  = app.sprockets

        yield self if block_given?
      end

      def define
        namespace :assets do
          super
        end
      end

      class << self
        def define(app)
          Task.new(app)
        end
        alias_method :define!, :define
      end
    end
  end
end