require 'guard'
require 'guard/guard'

module Guard
  class Jstd < Guard
    autoload :Runner, 'guard/jstd/runner'
    autoload :CaseFinder, 'guard/jstd/case_finder'
    autoload :Formatter, 'guard/jstd/formatter'
    autoload :Configuration, 'guard/jstd/configuration'

    def start
      UI.info "Guard::Jstd is running."
      Runner.start_server
    end

    def run_all
      Runner.run unless defined? Guard::CoffeeScript
    end

    def run_on_change(paths)
      cases = CaseFinder.find(paths)
      Runner.run(cases)
    end

    def self.configure
      yield Configuration
    end
  end
end
