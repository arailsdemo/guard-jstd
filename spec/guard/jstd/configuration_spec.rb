require "spec_helper"

describe Guard::Jstd::Configuration do
  let(:_module) { Guard::Jstd::Configuration }

  after do
    subject.reset!
  end

  describe ".reset!" do
    it "sets the java_path to the default" do
      subject.java_path = 'foo/bar.jar'
      subject.java_path.should == 'foo/bar.jar'
      subject.reset!

      subject.java_path.should == '$JSTESTDRIVER_HOME/JsTestDriver-1.3.2.jar'
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

    it "does not raise an error if there is no configuration file" do
      expect { subject.default_server_port }.to_not raise_exception
    end

    it "returns 4224 if there is no configuration file" do
      subject.default_server_port.should == "4224"
    end
  end
end
