require 'rake'
require 'rake/tasklib'
require 'rake/sprocketstask'

module Sinatra
  module Sprockets
    class RakeTask < Rake::TaskLib
      def initialize(app)
        namespace :assets do
          desc "Precompile assets"
          task :precompile do
            env = app.sprockets
            manifest = Sprockets::Manifest.new(env.index, app.assets_path)
            manifest.compile(app.assets_precompile)
          end

          desc "Clean assets"
          task :clean do
            FileUtils.rm_rf(app.assets_path)
          end
        end
      end
    end

    def self.rake_tasks(app)
      RakeTask.new(app)
    end
  end
end