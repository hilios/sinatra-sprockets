
require 'test_helper'

class Sprockets::Manifest
  # Remove output from Sprockets tasks
  def logger
    @logger ||= Logger.new($stdout)
    @logger.level = Logger::FATAL
    @logger
  end
end

class Sinatra::Sprockets::TasksHelper < MiniTest::Test
  def test_order
    :alpha
  end
  
  def test_task_definition
    assert_includes rake.tasks.map!(&:name), "assets:precompile"
    assert_includes rake.tasks.map!(&:name), "assets:clobber"
    assert_includes rake.tasks.map!(&:name), "assets:clean"
  end

  def test_0_precompile_task
    rake["assets:precompile"].invoke
    assert File.directory?(File.join(app.public_folder, app.assets_prefix))
    # Ensure every file was precompiled
    Dir['test/app/assets/**/*'].each do |file|
      file = file[16...file.length]
      path = app.sprockets[file].digest_path
      path = File.join(app.public_folder, app.assets_prefix, path)
      assert File.exists?(path)
    end
    # Ensure manifest file was created
    manifest_file = ::Sprockets::Manifest.new(app.sprockets, 
      File.join(app.public_folder, app.assets_prefix))
    File.exists?(manifest_file.path)
  end

  def test_1_clobber_task
    # Remove the compile directory
    rake["assets:clobber"].invoke
    refute File.directory?(File.join(app.public_folder, app.assets_prefix))
  end
end