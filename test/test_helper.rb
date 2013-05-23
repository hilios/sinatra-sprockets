ENV['RACK_ENV'] = 'test'
require 'app/mock'
require 'rack/test'
require 'minitest/autorun'
require 'mocha/setup'

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
end