require 'test_helper'

class Sinatra::Sprockets::DevelopmentServerTest < MiniTest::Test
  def app
    mock_base_app do
      # Set the app root manually
      set :root, File.expand_path('test/app')
      # Set enviroment before register the extension
      set :environment, :development
      register ::Sinatra::Sprockets
    end
  end

  def test_assets_request_on_development
    get('/assets/application.js')
    assert last_response.ok?
    assert_match /var app = {}/,    last_response.body, "Javascript did not required self"
    assert_match /var other = {}/,  last_response.body, "Javascript did not required tree"
    
    get('/assets/application.css')
    assert last_response.ok?
    assert_match /body{}/,          last_response.body, "Stylesheet did not required self"
    assert_match /.other{}/,        last_response.body, "Stylesheet did not required tree"
  end
end

class Sinatra::Sprockets::ProductionServerTest < MiniTest::Test
  def app
    mock_app do
      set :environment, :production
    end
  end

  def test_assets_request_on_development
    get('/assets/application.js')
    assert_equal 404, last_response.status
  end
end