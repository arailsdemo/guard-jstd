require "spec_helper"

describe Guard::Jstd::Formatter do
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

  let(:passed) do
    <<-PASSED
    ....
    Total 4 tests (Passed: 4; Fails: 0; Errors: 0) (4.00 ms)
      Chrome 10.0.648.204 Mac OS: Run 4 tests (Passed: 4; Fails: 0; Errors 0) (4.00 ms)
    PASSED
  end

  let(:klass) { ::Guard::Jstd::Formatter }

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
  end

  context "--all tests passed--" do
    subject { klass.new(passed) }

    its(:any_failed?) { should be_false }

    it "#notify should send :success arguments to Nofitier" do
      message = "Total 4 tests (Passed: 4; Fails: 0; Errors: 0) (4.00 ms)"
      ::Guard::Notifier.should_receive(:notify).with(
        message, { :title => klass::TITLES[:success], :image => :success }
      )
      subject.notify
    end
  end
end
