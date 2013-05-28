require 'test_helper'

class Sinatra::Sprockets::HelpersTest < MiniTest::Test

  def app
    mock_app do
      get('/asset/path')      { asset_path('image.gif') }

      get('/javascript/tag')  { javascript_tag('application') }
      get('/stylesheet/tag')  { stylesheet_tag('application') }

      get('/javascript')      { javascript(:application) }
      get('/javascripts')     { javascripts(:application, :other) }

      get('/stylesheet')      { stylesheet(:application) }
      get('/stylesheets')     { stylesheets(:application, :other) }
    end
  end

  def test_asset_path_helper
    get('/asset/path')
    assert_match %r(image-(.+?).gif),           last_response.body
  end

  def test_javascript_tag_helper
    get('/javascript/tag')
    assert last_response.ok?
    assert_match %r(application-(.+?).js),      last_response.body
    assert_match %r(<script (.+?)><\/script>),  last_response.body
  end

  def test_stylesheet_tag_helper
    get('/stylesheet/tag')
    assert last_response.ok?
    assert_match %r(application-(.+?).css),     last_response.body
    assert_match %r(<link (.+?)>),              last_response.body
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
    assert_match %r(application-(.+?).css),     last_response.body
    assert_match %r(<link (.+?)>),              last_response.body
    # Pluralized
    get('/stylesheets')
    assert last_response.ok?
    assert_match %r(application-(.+?).css),     last_response.body
    assert_match %r(other-(.+?).css),           last_response.body
    assert_match %r(<link (.+?)>),              last_response.body
  end

end