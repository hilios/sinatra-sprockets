ENV['RACK_ENV'] ||= 'test'
require 'app/test'
require 'rack/test'
require 'minitest/autorun'

class MiniTest::Test
  include Rack::Test::Methods

  def app
    TestApp
  end
end