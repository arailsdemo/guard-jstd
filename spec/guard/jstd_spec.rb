require "spec_helper"

describe Guard::Jstd do
  let(:klass) { Guard::Jstd }

  it "inherits from Guard" do
    klass.ancestors.should include Guard::Guard
  end
end
