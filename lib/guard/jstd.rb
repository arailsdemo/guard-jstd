require 'guard'
require 'guard/guard'

module Guard
  class Jstd < Guard
    autoload :Runner, 'guard/jstd/runner'
    autoload :CaseFinder, 'guard/jstd/case_finder'
    autoload :Formatter, 'guard/jstd/formatter'

    def start
      UI.info "Guard::Jstd is running."
    end

    def run_all
      Runner.run
    end

    def run_on_change(paths)
      cases = CaseFinder.find(paths)
      Runner.run(cases)
    end
  end
end
