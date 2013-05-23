require 'sinatra/base'
require './lib/sinatra/sprockets'

class TestApp < Sinatra::Base
  register Sinatra::Sprockets
end