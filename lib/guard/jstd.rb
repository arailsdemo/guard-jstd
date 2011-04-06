require 'guard'
require 'guard/guard'

module Guard
  class Jstd < Guard
    autoload :Runner, 'guard/jstd/runner'
    autoload :CaseFinder, 'guard/jstd/case_finder'

  end
end
