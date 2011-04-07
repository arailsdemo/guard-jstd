# Guard::Jstd

Guard::Jstd provides autotest functionality for your test driven JavaScript development with JsTestDriver. This gem was inspired by the [jstdutil gem](http://cjohansen.no/en/javascript/jstdutil_a_ruby_wrapper_over_jstestdriver) and modeled after the [Guard::RSpec gem.](https://github.com/guard/guard-rspec)

## Installing the gem:

From the command line:

    $ gem install guard-jstd

Or in your Gemfile:

    group :test do
      gem "guard-jstd"
    end

Generate the suggested Guardfile with:

    guard init jstd

## Usage

See the [Guard](http://github.com/guard/guard) gem README for more information about using Guard.

If you want to use CoffeeScript in your development, add the [guard-coffeescript gem.](https://github.com/guard/guard-coffeescript)

## JsTestDriver

Currently, Guard::Jstd requires that you define an environment variable, $JSTESTDRIVER_HOME, to specify where the JsTestDriver .jar file is located at on your system. More information about setting up JsTestDriver on your system can be [found here](http://www.arailsdemo.com/posts/46) or on the JsTestDriver [homepage.](http://code.google.com/p/js-test-driver/)
