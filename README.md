# Guard::Jstd

Guard::Jstd provides autotest functionality for your test driven JavaScript development with JsTestDriver. This gem was inspired by the [jstdutil gem](http://cjohansen.no/en/javascript/jstdutil_a_ruby_wrapper_over_jstestdriver) and modeled after the [Guard::RSpec gem.](https://github.com/guard/guard-rspec)

## Installing the gem

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

By default, Guard::Jstd will attempt to start the JsTestDriver server. This is done as a forked process, so when you stop Guard with <tt>Ctrl-C</tt>, the Jstd server will also stop.

<tt>Ctrl-\\</tt> or <tt>Ctrl-Z</tt> will run all of your tests.

## Configuration

You can specify some configuration options by passing a block to Jstd.configure. This must appear after the 'guard "jstd"' definition in your Guardfile. An example configuration is given below.

    guard "jstd" do
      # mappings here
    end

    Jstd.configure do |c|
      c.java_path = "~/my/path/JsTestDriver-1.3.2.jar"
      c.browser_paths = "\`which open\`"
      c.jstd_config_path = 'someJsTestDriver.conf'
      c.start_server = false
      c.capture_browser = false    # false is the default
    end

## Defaults

If you have a "$JSTESTDRIVER_HOME" environment variable set on your system, Jstd will automatically look for your JsTestDriver .jar file there. Otherwise, you have to configure the path with "c.java_path".

On start up, Jstd will attempt to start the JsTestDriver server. You can prevent this with "c.start_server = false". The server_port is determined from your JsTestDriver configuration file. If this file does not exist, then the default port is 4224. If you really want Jstd to start the server in a specified port, then you can do that with "c.server_port = 1234".

If you set "c.capture_browser = true", then Jstd will attempt to capture the browser(s) defined in "c.browser_path" when the server is started. Otherwise, you have to manually capture browsers after the server starts.

The default JsTestDriver configuration file name is 'jsTestDriver.conf'. If you are using something else, then use "c.jstd_config_path".

## JsTestDriver

Information about setting up JsTestDriver on your system can be [found here](http://www.arailsdemo.com/posts/46) or on the JsTestDriver [homepage.](http://code.google.com/p/js-test-driver/)

## Guard::CoffeeScript

If you want to use CoffeeScript in your development, add the [guard-coffeescript gem.](https://github.com/guard/guard-coffeescript) To avoid conflict with Guard::CoffeeScript, <tt>Ctrl-\\</tt> is disabled for Guard::Jstd. Use <tt>Ctrl-Z</tt> instead to run all tests.
