Sinatra::Sprockets
==================

Plug and play extension for sinatra that mimic rails assets pipeline through Sprockets.

This gem allows you easly deploy assets via Sprockets assets pipeline just as Rails does, also help you configure the rake tasks for compression. The goal is to have a headless configuration extension and be tested (all other aren't) to give users a fast access to all Sprockets goodness.

Installation & Usage
--------------------

Set on your Gemset file if you are using Bundler:

```ruby
gem 'sinatra-sprockets-chain'
# Don't forget the js evaluator: gem 'therubyracer'
```

If you are using the Classic style just require the extension.

```ruby
require 'sinatra'
require 'sinatra/sprockets'

# ... Your app
```

On the other hand if you use the Modular approach, besides requiring register the extension on your Sinatra application.

```ruby
require 'sinatra/base'
require 'sinatra/sprockets'

class Hello < Sinatra::Base
  register Sinatra::Sprockets

  # ... Your app
end
```

Following the default configuration you just need to create the `/assets` folder and Sprockets will search for `application.js` and `application.css` to precompile (if you want to set-up a different structure jump to the [configuration](#configuration) chapter). The default folder schema is:

```
hello/
| assets/
| | application.js
| | application.css
|
| sinatra_app.rb
```

In the application.(js|css) you can include your requirements:

```css
/*
 *= require vendor/normalize
 *= require_self
 *= require_tree .
 */
```

```js
//= require vendor/normalize
//= require_self
//= require_tree .
```

Compilation & Production environment
------------------------------------

By default Sprockets don't serve your file in production so it's up to you compile them, just set-up your `Rakefile` and run the `assets:precompile` task.

```ruby
require 'sinatra/sprockets/task'
require 'sintra_app'

# This will define the following task
#   rake assets:precompile
#   rake assets:clobber
#   rake assets:clean
Sinatra::Sprockets.rake_tasks(App)
```

Helpers
-------

This gem come bundled with [sprockets-helpers](https://github.com/petebrowne/sprockets-helpers) to help the path resolution of your assets inside sprockets or your application. All methods available in the gem will be at your disposal as helpers once you register the extension.

```css
body {
  background-image: image-url('cat.png');
}
```

```erb
<img src="<%= image_path('hello.jpg') %>" />
<script src="<%= javascript_path 'application' %>"></script>
<link rel="stylesheet" href="<%= stylesheet_path 'application' %>">

<%= javascript_tag 'application' %>
<%= stylesheet_tag 'application' %>

<!-- Handle the expansion of assets for debugging like Rails -->
<%= javascript_tag 'application', expand: true %>
```

Configuration
-------------

You can control Sprockets entirely using Sinatra `set` configuration method. Bellow a list of the configuration:

```ruby
# Main
set :assets_prefix, '/assets'
set :assets_path,   Dir['app/assets/**'] # All folders in asset
set :assets_precompile,     %w(application.js application.css)
# Compilers
set :assets_css_compressor, :sass
set :assets_js_compressor,  :uglifier
# Helper
set :assets_host,           'cdn.host.com'
set :assets_protocol,       :relative # or :http or :https
set :assets_digest,         true
set :assets_expand,         false
# Debug mode automatically sets
# expand = true, digest = false, manifest = false
set :assets_debug,          true
# Use this configuration with caution
set :assets_manifest_file,  File.join(public_folder, "assets/manifest.json")
```

Minification
------------

As seen on the last example of the configurantion you can configure other libraries to compress your assets, Sinatra::Sprockets handle them transparently and it's up to you to require the gems.

#### SASS

```ruby
gem 'sass'
set :assets_css_compressor, :sass
```

#### Closure

```ruby
gem 'closure-compiler'
set :assets_css_compressor, :closure
```

#### Uglifier

```ruby
gem 'uglifier'
set :assets_css_compressor, :uglifier
```

#### YUI Compressor

```ruby
gem 'yui-compressor'
set :assets_css_compressor, :yui
```

### Compass and others gems

The integration is easily done by requiring the [sprockets-sass](https://github.com/petebrowne/sprockets-sass) gem.

None the less any gem that have integration with the Sprockets will work seamlessly. If you need any other configuration you can call Sprockets configuration directly.

Copyrights
----------

Copyrights 2012 [**Edson Hilios**](http://edson.hilios.com.br) edson (at) hilios (dot) com (dot) br

This software is licensed under [MIT-LICENSE](https://github.com/hilios/sinatra-sprockets-wheel/blob/master/MIT-LICENSE)
