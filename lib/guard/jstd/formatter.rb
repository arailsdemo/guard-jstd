module Guard
  class Jstd
    class Formatter
      TITLES =
        {
          :failed => 'You have failing tests.',
          :success => "All of your tests passed."
        }

      COLORS =
        {
          :success => "\e[32m",
          :failed => "\e[31m"
        }

      def self.notify(results)
        formatter = self.new(results)
        formatter.notify
        formatter.to_terminal
      end

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

      def colorize_results
       lines.collect do |line|
          if line =~ /failed/
            colorize(line, :failed)
          elsif line =~ /Fails: (\d+);/
            status = $1.to_i == 0 ? :success : :failed
            colorize(line, status)
          else
            line
          end
        end.join("\n")
      end

      def to_terminal
        UI.info(colorize_results, :reset => true)
      end

      private

      def colorize(text, status)
        "#{COLORS[status]}#{text}\e[0m"
      end
    end
  end
end
