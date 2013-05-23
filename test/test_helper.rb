# ENV['RACK_ENV'] ||= 'test'
require 'app/test'
require 'rack/test'
require 'minitest/autorun'

class MiniTest::Test
  include Rack::Test::Methods

  def setup
    ENV['RACK_ENV'] = 'test'
  end

  def app
    TestApp
  end

  def mock_app(&block)
    Class.new(TestApp, &block)
  end

  def mock_base_app
     Class.new(Sinatra::Base, &block) 
  end
end