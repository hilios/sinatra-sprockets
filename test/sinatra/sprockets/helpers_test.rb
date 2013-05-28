require 'test_helper'

class Sinatra::Sprockets::HelpersTest < MiniTest::Test

  def app
    mock_app do
      get('/javascript')  { javascript_tag('application') }

      get('/stylesheet')  { stylesheet_tag('application') }
    end
  end

  def test_javascript_helper
    get('/javascript')
    assert last_response.ok?
    assert_match %r(application-(.+?).js),      last_response.body
    assert_match %r(<script (.+?)><\/script>),  last_response.body
  end

  def test_stylesheet_helper
    get('/stylesheet')
    assert last_response.ok?
    assert_match %r(application-(.+?).css), last_response.body
    assert_match %r(<link (.+?)>),          last_response.body
  end

end