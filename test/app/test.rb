require 'sinatra/base'
require 'sinatra/sprockets'

class TestApp < Sinatra::Base
  register Sinatra::Sprockets
end