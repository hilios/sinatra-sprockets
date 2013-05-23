require 'sinatra/base'
require './lib/sinatra/sprockets'

class Mock < Sinatra::Base
  register Sinatra::Sprockets
end