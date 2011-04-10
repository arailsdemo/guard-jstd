require 'Forwardable'

module Guard
  class Jstd
    module Runner
      class << self
        extend Forwardable

        [:java_path, :browser_paths, :server_port,
        :jstd_config_path].each do |config|
          def_delegator Configuration, config, config
        end

        def run(tests="all")
          UI.info("Running #{tests}")
          results = `#{java_command} --tests #{tests}`
          Formatter.notify(results)
        end

        def start_server
          if Configuration.start_server
            browser_opt = Configuration.capture_browser ?
                          " --browser #{browser_paths}" : ""
            pid = fork {
              trap('QUIT', 'IGNORE')
              trap('TSTP', 'IGNORE')
              `#{java_command} --port #{server_port}#{browser_opt}`
            }
            Process.detach(pid)
            UI.info "JsTestDriver server started on port #{server_port}"
          end
        end

        def java_command
          "java -jar #{java_path} --config #{jstd_config_path}"
        end
      end
    end
  end
end
