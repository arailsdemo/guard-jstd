module Guard
  class Jstd
    module Configuration
      class << self
        attr_writer :java_path, :browser_paths, :server_port,
                    :jstd_config_path

        def reset!
          @java_path = nil
          @browser_paths = nil
          @server_port = nil
          @jstd_config_path = nil
        end

        def java_path
          @java_path ||= '$JSTESTDRIVER_HOME/JsTestDriver-1.3.2.jar'
        end

        def browser_paths
          @browser_paths ||= "\`which open\`"
        end

        def server_port
          @server_port ||= default_server_port
        end

        def jstd_config_path
          @jstd_config_path ||= 'jsTestDriver.conf'
        end

        def default_server_port
          begin
            conf = File.read(jstd_config_path)
            conf.scan(/server:.*:(\d+)$/).to_s
          rescue
            '4224'
          end
        end
      end
    end
  end
end
