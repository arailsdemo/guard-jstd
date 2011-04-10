require "spec_helper"

describe Guard::Jstd::Formatter do
  let(:klass) { ::Guard::Jstd::Formatter }

  let(:failed) do
    <<-FAILED
    ..
    Total 2 tests (Passed: 1; Fails: 1; Errors: 0) (1.00 ms)
      Chrome 10.0.648.204 Mac OS: Run 2 tests (Passed: 1; Fails: 1; Errors 0) (1.00 ms)
        Sneaky3.test failed (1.00 ms): AssertError: expected true but was false
          AssertError: expected true but was false
              at Object.test (http://0.0.0.0:4224/test/javascripts/test/extra_test.js:9:5)
    FAILED
  end

  context "--failed test--" do
    subject { klass.new(failed) }

    its(:any_failed?) { should be_true }

    it "#notify sends :failed arguments to Nofitier" do
      message = "Total 2 tests (Passed: 1; Fails: 1; Errors: 0) (1.00 ms)"
      ::Guard::Notifier.should_receive(:notify).with(
        message, { :title => klass::TITLES[:failed], :image => :failed }
      )
      subject.notify
    end

    describe "#colorized_results" do
      it "adds color to the failure message" do
        subject.colorize_results.should match /\[31m\s+Sneaky3.test/
      end

      it "adds color to the failure tally" do
        subject.colorize_results.should match /\[31mFails: 1/
      end

      it "adds color to the passed tally" do
          subject.colorize_results.should match /\[32mPassed: 1/
      end
    end

    it "#to_terminal sends colorized results to UI" do
      subject.stub(:colorize_results) { failed }
      ::Guard::UI.should_receive(:info).with(
        failed, {:reset => true}
      )
      subject.to_terminal
    end
  end

  context "--all tests passed--" do
    let(:passed) do
      <<-PASSED
      ....
      Total 4 tests (Passed: 4; Fails: 0; Errors: 0) (4.00 ms)
        Chrome 10.0.648.204 Mac OS: Run 4 tests (Passed: 4; Fails: 0; Errors 0) (4.00 ms)
      PASSED
    end

    subject { klass.new(passed) }

    its(:any_failed?) { should be_false }

    it "#notify should send :success arguments to Nofitier" do
      message = "Total 4 tests (Passed: 4; Fails: 0; Errors: 0) (4.00 ms)"
      ::Guard::Notifier.should_receive(:notify).with(
        message, { :title => klass::TITLES[:success], :image => :success }
      )
      subject.notify
    end

    it "#colorized_results adds color to the successful overview line" do
      colorized = subject.colorize_results
      colorized.should match /\[32m\s*Total/
    end
  end

  context "--errors present--" do
    context "-Java error-" do
      let(:java_error) do
        <<-ERROR
        java.lang.RuntimeException: Connection error on: sun.net.www.protocol.
                at com.google.jstestdriver.HttpServer.postJson(HttpServer.java:124)
        ERROR
      end

      subject { klass.new(java_error) }

      it "#notify should send :error arguments to Nofitier" do
        message = "java.lang.RuntimeException: Connection error on: sun.net.www.protocol."
        ::Guard::Notifier.should_receive(:notify).with(
          message, { :title => klass::TITLES[:error], :image => :failed }
        )
        subject.notify
      end

      it "#colorized_results adds color to the error description line" do
        subject.colorize_results.should match /\[31m\s+java.lang./
      end
    end

    context "-JavaScript error-" do
      let(:javascript_error) do
        <<-ERROR

        Total 0 tests (Passed: 0; Fails: 0; Errors: 0) (0.00 ms)
          Chrome 10.0.648.204 Mac OS: Run 1 tests (Passed: 0; Fails: 0; Errors 1) (0.00 ms)
            error loading file: /test/javascripts/test/hello_test.js:33: Uncaught SyntaxError: Unexpected token ;
        Tests failed: Tests failed. See log for details.
        ERROR
      end

      subject { klass.new(javascript_error) }

      it "#colorized_results add color to the summary line" do
        subject.colorize_results.should match /\[31mErrors 1/
      end
    end
  end

  context ".notify" do
    subject { klass }

    before do
      @formatter = double.as_null_object
      subject.should_receive(:new).with(failed) { @formatter }
    end

    it "calls #notify" do
      @formatter.should_receive(:notify)
      subject.notify(failed)
    end

    it "call #to_terminal" do
      @formatter.should_receive(:to_terminal)
      subject.notify(failed)
    end
  end
end
