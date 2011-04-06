require 'guard'
require 'guard/guard'

module Guard
  class Jstd < Guard
    autoload :Runner, 'guard/jstd/runner'

  end
end
