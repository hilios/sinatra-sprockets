require 'sprockets-helpers'

module Sinatra
  module Sprockets
    module Helpers
      include ::Sprockets::Helpers

      def stylesheets(*args)
        args.map! do |asset|
          asset = "#{asset}.css" if asset.is_a? Symbol
          stylesheet_tag(asset)
        end
        args.join("")
      end
      alias_method :stylesheet, :stylesheets

      def javascripts(*args)
        args.map! do |asset|
          asset = "#{asset}.js" if asset.is_a? Symbol
          javascript_tag(asset)
        end
        args.join("")
      end
      alias_method :javascript, :javascripts
    end
  end
end