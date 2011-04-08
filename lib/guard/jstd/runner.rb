module Guard
  class Jstd
    module Runner
      class << self
        def java_command
          "java -jar #{java_path}"
        end

        def run(tests="all")
          UI.info("Running #{tests}")
          results = `#{java_command} --tests #{tests}`
          Formatter.notify(results)
        end

        def start_server
          pid = fork { `java -jar #{java_path} --port #{port} --browser #{browser_paths}` }
          Process.detach(pid)
          UI.info "JsTestDriver server started on port #{port}"
        end

        private

        def java_path
          Configuration.java_path
        end

        def browser_paths
          Configuration.browser_paths
        end

        def port
          Configuration.default_server_port
        end
      end
    end
  end
end
