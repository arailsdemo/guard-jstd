require "spec_helper"

describe Guard::Jstd::Runner do
  let(:config) { Guard::Jstd::Configuration }

  describe ".run" do
    let(:test) { "HelloTest" }

    it "sends the test results to the Formatter" do
      subject.stub(:"`") { 'results' }
      Guard::Jstd::Formatter.should_receive(:notify).with('results')
      subject.run
    end

    it ".java_command uses Configuration java_path and jstd_config_path" do
      Guard::Jstd::Formatter.stub(:notify)
      config.java_path = 'foo'
      config.jstd_config_path = 'bar'
      subject.should_receive(:"`").with(
        "java -jar foo --config bar --tests all"
      )
      subject.run
      Guard::Jstd::Configuration.reset!
    end

    context "--JsTestDriver command--" do
      before do
        subject.stub(:java_command) { 'hooha' }
        Guard::Jstd::Formatter.stub(:notify)
      end

      it "can run all tests" do
        subject.should_receive(:"`").with(
          "hooha --tests all"
        )
        subject.run
      end

      it "can run a single TestCase" do
        subject.should_receive(:"`").with(
          "hooha --tests #{test}"
        )
        subject.run(test)
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
    context "--given some configuration--" do
      before do
        config.java_path = 'java'
        config.browser_paths = 'browsers'
        config.server_port = 1234
      end

      after { config.reset! }

      it "does not start the server if configuration is false" do
        config.start_server = false
        subject.should_not_receive(:fork)
        subject.start_server
      end

      it "detaches a forked process" do
        subject.stub(:fork) { 1 }
        Process.should_receive(:detach).with(1)
        subject.start_server
      end

      it "sends a message to UI" do
        subject.stub(:fork)
        Process.stub(:detach)
        Guard::UI.should_receive(:info).with(
          "JsTestDriver server started on port 1234"
        )
        subject.start_server
      end

      context "--in the forked process--" do
        before do
          subject.stub(:java_command) { 'hooha' }
          Process.stub(:detach)
        end

        it "starts the JsTestDriver server" do
          subject.should_receive("`").with('hooha --port 1234') { 'hooha' }
          subject.should_receive(:fork) { |&block|
            block.call.should == 'hooha'
          }
          subject.start_server
        end

        it "opens the browser if configurated to do so" do
          config.capture_browser = true
          subject.should_receive("`").with('hooha --port 1234 --browser browsers') { 'hooha' }
          subject.should_receive(:fork) { |&block| block.call }
          subject.start_server
        end

        it "traps the 'QUIT' and 'TSTP' signals before sending it to the child process" do
          subject.should_receive("`").with('hooha --port 1234') { 'hooha' }
          subject.should_receive(:trap).with('QUIT', 'IGNORE')
          subject.should_receive(:trap).with('TSTP', 'IGNORE')
          subject.should_receive(:fork) { |&block| block.call }
          subject.start_server
        end
      end
    end
  end
end
