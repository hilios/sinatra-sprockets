require 'test_helper'

class Sinatra::Sprockets::ServerTest < MiniTest::Test
  def setup
    @old_env = ENV['RACK_ENV'].clone
    ENV['RACK_ENV'] = 'development'
  end

  def teardown
    ENV['RACK_ENV'] = @old_env
  end

  def test_assets_request_on_development
    get('/assets/application.js')
    assert last_response.ok?
    assert_match /var app = {}/,    last_response.body, "Javascript did not required self"
    assert_match /var other = {}/,  last_response.body, "Javascript did not required tree"

    get('/assets/application.css')
    assert last_response.ok?
    assert_match /body{}/,    last_response.body, "Stylesheet did not required self"
    assert_match /.other{}/,  last_response.body, "Stylesheet did not required tree"
  end
end