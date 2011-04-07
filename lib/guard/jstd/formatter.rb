module Guard
  class Jstd
    class Formatter
      TITLES =
        {
          :failed => 'You have failing tests.',
          :success => "All of your tests passed."
        }

      attr_reader :results, :lines

      def initialize(results)
        @results = results
        @lines = results.split("\n")
      end

      def any_failed?
        @failed ||= results.match(/failed/)
      end

      def notify
        status = any_failed? ? :failed : :success
        ::Guard::Notifier.notify( lines[1].lstrip,
          { :title => TITLES[status], :image => status }
        )
      end
    end
  end
end
