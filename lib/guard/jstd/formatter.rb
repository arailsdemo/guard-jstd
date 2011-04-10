module Guard
  class Jstd
    class Formatter
      TITLES =
        {
          :failed => 'You have failing tests.',
          :success => "All of your tests passed.",
          :error => "You had some errors."
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

      def errors_present?
        lines[0].match(/error/)
      end

      def notify
        if errors_present?
          status = :error
          image = { :image => :failed }
          message = lines[0]
        else
          status = any_failed? ? :failed : :success
          image = { :image => status }
          message = lines[1]
        end

        ::Guard::Notifier.notify( message.lstrip,
          { :title => TITLES[status] }.merge(image)
        )
      end

      def colorize_results
       lines.collect do |line|
          if line =~ /failed|error/
            colorize(line, line, :failed)
          else
            if line =~ /((Passed: (\d+)); (Fails: (\d+)); (Errors:? (\d+)))/
              if $5 == "0" && $7 == "0"
                colorize(line, line, :success)
              else
#               if $3 != "0"
#                 colorize(line, $2, :success)
#               end
                [3, 5, 7].each do |tally|
                  if eval("$#{tally}") != "0"
                    status = tally == 3 ? :success : :failed
                    colorize(line, eval("$#{tally - 1}"), status)
                  end
                end
              end
            end

            line
          end
        end.join("\n")
      end

      def to_terminal
        UI.info(colorize_results, :reset => true)
      end

      private

      def colorize(text, part, status)
        text.gsub!(part, "#{COLORS[status]}#{part}\e[0m")
      end
    end
  end
end
