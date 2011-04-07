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
      let(:java_command) { Guard::Jstd::Runner::java_command }

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
end
