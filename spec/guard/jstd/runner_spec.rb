require "spec_helper"

describe Guard::Jstd::Runner do
  describe ".run" do
    let(:test) { "HelloTest" }

    it "sends the test results to the Formatter" do
      subject.stub(:"`") { 'results' }
      Guard::Jstd::Formatter.should_receive(:notify).with('results')
      subject.run
    end

    context "--JsTestDriver command--" do
      let(:java_command) { "java -jar $JSTESTDRIVER_HOME/JsTestDriver-1.3.2.jar --tests" }

      before { Guard::Jstd::Formatter.stub(:notify) }

      it "can run all tests" do
        subject.should_receive(:"`").with(
          "#{java_command} all"
        )
        subject.run
      end

      it "can run a single TestCase" do
        subject.should_receive(:"`").with(
          "#{java_command} #{test}"
        )
        subject.run(test)
      end

      it "uses Configuration.java_path" do
        Guard::Jstd::Configuration.java_path = 'foo'
        subject.should_receive(:"`").with(
          "java -jar foo --tests all"
        )
        subject.run
        Guard::Jstd::Configuration.reset!
      end
    end

    it "tells UI which tests are running" do
      Guard::Jstd::Formatter.stub(:notify)
      subject.stub(:"`")
      Guard::UI.should_receive(:info).with(
        "Running #{test}"
      )
      subject.run(test)
    end
  end

  describe ".start_server" do
    before do
      @java_command = "java -jar $JSTESTDRIVER_HOME/JsTestDriver-1.3.2.jar --port 4224 --browser 'path'"
      ::Guard::Jstd::Configuration.stub(:browser_paths) { "'path'" }
    end

    it "forks a process to start the JsTestDriver server" do
      Process.stub(:detach)
      subject.should_receive("`").with(@java_command) { 'command' }
      subject.should_receive(:fork) { |&block|
        block.call.should == 'command'
      }
      subject.start_server
    end

    it "detaches the forked process" do
      subject.stub(:fork) { 1 }
      Process.should_receive(:detach).with(1)
      subject.start_server
    end

    it "sends a message to UI" do
      subject.stub(:fork)
      Process.stub(:detach)
      Guard::UI.should_receive(:info).with(
        "JsTestDriver server started on port 4224"
      )
      subject.start_server
    end
  end
end
