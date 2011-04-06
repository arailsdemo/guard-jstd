require "spec_helper"

describe Guard::Jstd do
  let(:klass) { Guard::Jstd }

  it "inherits from Guard" do
    klass.ancestors.should include Guard::Guard
  end

  it "#start sends a message to UI" do
    ::Guard::UI.should_receive(:info).with(
      "Guard::Jstd is running."
    )
    subject.start
  end

  it " #run_all runs all tests" do
    klass::Runner.should_receive(:run)
    subject.run_all
  end

  describe "#run_on_change" do
    it "starts the Runner with the corresponding TestCases" do
      paths = ['foo/bar.js', 'hand/foot.js']
      cases = 'First,Second'
      klass::CaseFinder.should_receive(:find).with(paths) { cases }
      klass::Runner.should_receive(:run).with(cases)
      subject.run_on_change(paths)
    end
  end
end
