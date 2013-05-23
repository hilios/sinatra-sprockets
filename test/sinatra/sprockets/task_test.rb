
require 'test_helper'

class Sinatra::Sprockets::TasksHelper < MiniTest::Test
  def setup
    require 'rake'
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake::Task.define_task(:environment)
    # Define the task
    ::Sinatra::Sprockets::Task.define(app) do
      log_level = nil
    end
  end

  def test_task_definition
    assert_includes @rake.tasks.map!(&:name), "assets:precompile"
    assert_includes @rake.tasks.map!(&:name), "assets:clobber"
    assert_includes @rake.tasks.map!(&:name), "assets:clean"
  end

  def test_0_precompile_task
    @rake["assets:precompile"].invoke
    assert File.directory?(File.join(app.public_folder, app.assets_prefix))
    # Ensure every file was precompiled
    app.assets_precompile.each do |file|
      path = app.sprockets[file].digest_path
      path = File.join(app.public_folder, app.assets_prefix, path)
      assert File.file?(path)
    end
  end

  def test_1_clobber_task
    # Remove the compile directory
    @rake["assets:clobber"].invoke
    refute File.directory?(File.join(app.public_folder, app.assets_prefix))
  end
end