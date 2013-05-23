require 'test_helper'

class Sinatra::SprocketsTest < MiniTest::Test
  def test_start_the_sprockets_environmet
    assert_instance_of Sprockets::Environment, app.sprockets
    assert_equal app.root, app.sprockets.root
  end
end