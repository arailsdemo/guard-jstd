require "spec_helper"

describe Guard::Jstd do
  let(:klass) { Guard::Jstd }

  it "inherits from Guard" do
    klass.ancestors.should include Guard::Guard
  end

  describe "#start" do
    it "sends a message to UI" do
      klass::Runner.stub(:start_server)
      ::Guard::UI.should_receive(:info).with(
        "Guard::Jstd is running."
      )
      subject.start
    end

    it "calls Runner.start_server" do
      klass::Runner.should_receive(:start_server)
      subject.start
    end
  end

  describe "#run_all" do
    it "runs all tests" do
      klass::Runner.should_receive(:run)
      subject.run_all
    end

# TODO remove ::Guard::CoffeeScript when test is done
    it "does not run tests if Guard::CoffeeScript is present" do
      ::Guard::CoffeeScript = Class.new
      Guard.stub(:guards) { [::Guard::CoffeeScript.new, ::Guard::Jstd.new] }
      klass::Runner.should_not_receive(:run)
#      Object.send :remove_const, "::Guard::CoffeeScript"
      subject.run_all
    end
  end

  describe "#reload" do
    it "runs all without checking for CoffeeScript" do
      klass::Runner.should_receive :run
      subject.reload
    end
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

  it ".configure yields the Configuration module" do
    Guard::Jstd.configure do |c|
      c.should == Guard::Jstd::Configuration
    end
  end
end
