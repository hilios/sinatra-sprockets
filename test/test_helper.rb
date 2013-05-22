ENV['RACK_ENV'] ||= 'test'
require 'minitest/autorun'
require 'rack/test'

require 'sinatra/base'
require 'sinatra/sprockets'

class TestApp < Sinatra::Base
  register Sinatra::Sprockets
end

class MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp
  end
end