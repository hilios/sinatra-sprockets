ENV['RACK_ENV'] = 'test'
require 'app/mock'
require 'rack/test'
require 'minitest/autorun'

class MiniTest::Test
  include Rack::Test::Methods

  def app
    Mock
  end

  def mock_app(&block)
    Class.new(Mock, &block)
  end

  def mock_base_app(&block)
     Class.new(Sinatra::Base, &block)
  end

  def rake
    require 'rake'
    @rake ||= lambda {
      rake = Rake::Application.new
      Rake.application = rake
      Rake::Task.define_task(:environment)
      # Define the task
      ::Sinatra::Sprockets::Task.define(app)
      return rake
    }.call
  end
end