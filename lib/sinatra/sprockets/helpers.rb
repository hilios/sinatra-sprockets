module Helpers
  include Sprockets::Helpers

  def stylesheet(*args)
    args.map! do |asset|
      asset = "#{asset}.css" if asset.is_a? Symbol
      "<link href='#{asset_path(asset)}' rel='stylesheet' type='text/css' />"
    end
    args.join("\n")
  end

  def javascript(*args)
    args.map! do |asset|
      asset = "#{asset}.js" if asset.is_a? Symbol
      "<script type='text/javascript' src='#{asset_path(asset)}'></script>"
    end
    args.join("\n")
  end
end