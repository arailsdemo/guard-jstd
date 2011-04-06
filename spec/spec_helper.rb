require 'rspec'
require 'guard/jstd'

RSpec.configure do |config|
  config.before(:each) do
    ENV["GUARD_ENV"] = 'test'
  end

  config.after(:each) do
    ENV["GUARD_ENV"] = nil
  end
end
