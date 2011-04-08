require "spec_helper"

describe Guard::Jstd::Configuration do
  let(:_module) { Guard::Jstd::Configuration }

  after do
    subject.reset!
  end

  describe ".jar_home" do
    it "uses $JSTESTDRIVER_HOME when present" do
      dir = "path\n"
      subject.should_receive("`").with(
        "echo $JSTESTDRIVER_HOME"
      ).and_return(dir)
      subject.jar_home.should == "path"
    end

    it "uses the default when $JSTESTDRIVER_HOME isn't present" do
      subject.should_receive("`").with(
        "echo $JSTESTDRIVER_HOME"
      ).and_return("")
      subject.jar_home.should == '~/bin'
    end
  end

  describe ".jar_path" do
    before { subject.stub(:jar_home).and_return("/path") }

    it "finds the .jar file in the jar_home" do
      Dir.should_receive(:glob).with("/path/jstest*.jar", File::FNM_CASEFOLD) { ["file.jar"] }
      subject.jar_path.should == "file.jar"
    end

    it "exits if the .jar file isn't found" do
      Dir.should_receive(:glob).with("/path/jstest*.jar", File::FNM_CASEFOLD) { [] }
      Guard::UI.should_receive(:info)
      expect { subject.jar_path }.to raise_error
    end
  end

  describe ".default_server_port" do
    def conf
      <<-FILE
server: http://0.0.0.0:2345

load:
  - javascripts/lib/*.js
  - javascripts/src/*.js
  - javascripts/test/*.js
      FILE
    end

    before do
      subject.stub(:jstd_config_path) { 'foo' }
    end

    it "gets the default from the JsTestDriver configuration file" do
      File.should_receive(:read).with("foo") { conf }
      subject.default_server_port.should == "2345"
    end

    it "returns 4224 if there is no configuration file" do
      subject.default_server_port.should == "4224"
    end
  end

  describe ".reset!" do
    it "sets the java_path to the default" do
      subject.stub(:jar_path) { "home" }

      subject.java_path = 'foo/bar.jar'
      subject.java_path.should == 'foo/bar.jar'
      subject.reset!

      subject.java_path.should == 'home'
    end

    it "sets the browser_paths to the default" do
      subject.browser_paths = 'path'
      subject.browser_paths.should == 'path'
      subject.reset!

      subject.browser_paths.should == "\`which open\`"
    end

    it "sets the server_port to the default" do
      subject.stub(:default_server_port) { 123 }
      subject.reset!

      subject.server_port.should == 123
    end

    it "sets the jstd_config_path to the default" do
      subject.jstd_config_path = 'hi'
      subject.jstd_config_path.should == 'hi'
      subject.reset!

      subject.jstd_config_path.should == 'jsTestDriver.conf'
    end

    it "sets the start_server option to true" do
      subject.start_server = false
      subject.start_server.should == false
      subject.reset!

      subject.start_server.should == true
    end

    it "sets the capture_browser option to false" do
      subject.capture_browser = true
      subject.capture_browser.should == true
      subject.reset!

      subject.capture_browser.should == false
    end
  end
end
