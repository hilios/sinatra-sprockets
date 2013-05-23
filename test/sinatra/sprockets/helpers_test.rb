require 'test_helper'
# require './lib/sinatra/sprockets/helpers'

class Sinatra::Sprockets::HelpersTest < MiniTest::Test

  def app
    mock_app do
      get('/javascript')  { javascript(:application) }
      get('/javascripts') { javascripts(:application, :other) }

      get('/stylesheet')  { stylesheet(:application) }
      get('/stylesheets') { stylesheets(:application, :other) }
    end
  end

  def test_javascript_helper
    get('/javascript')
    assert last_response.ok?
    assert_match %r(application-(.+?).js),      last_response.body
    assert_match %r(<script (.+?)><\/script>),  last_response.body
    # Pluralized
    get('/javascripts')
    assert last_response.ok?
    assert_match %r(application-(.+?).js),      last_response.body
    assert_match %r(other-(.+?).js),            last_response.body
    assert_match %r(<script (.+?)></script>),   last_response.body
  end

  def test_stylesheet_helper
    get('/stylesheet')
    assert last_response.ok?
    assert_match %r(application-(.+?).css), last_response.body
    assert_match %r(<link (.+?)/>),         last_response.body
    # Pluralized
    get('/stylesheets')
    assert last_response.ok?
    assert_match %r(application-(.+?).css), last_response.body
    assert_match %r(other-(.+?).css),       last_response.body
    assert_match %r(<link (.+?)/>),         last_response.body
  end

end