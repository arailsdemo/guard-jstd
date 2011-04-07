module Guard
  class Jstd
    module Runner
      class << self
        def java_command
          "java -jar $JSTESTDRIVER_HOME/JsTestDriver-1.3.2.jar --tests"
        end

        def run(tests="all")
          UI.info("Running #{tests}")
          results = `#{java_command} #{tests}`
          Formatter.notify(results)
        end
      end
    end
  end
end
