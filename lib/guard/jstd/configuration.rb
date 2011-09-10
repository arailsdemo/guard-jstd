module Guard
  class Jstd
    module Configuration
      class << self
        METHODS = [:java_path, :browser_paths, :server_port,
                    :jstd_config_path, :start_server, :capture_browser]

        METHODS.each do |method|
          attr_writer method
        end

        def reset!
          METHODS.each { |method| instance_variable_set("@#{method.to_s}", nil) }
          @jar_home = nil
        end

        def java_path
          @java_path ||= jar_path
        end

        def browser_paths
          @browser_paths ||= "\`which open\`"
        end

       def jstd_config_path
          @jstd_config_path ||= 'jsTestDriver.conf'
        end

        def server_port
          @server_port ||= default_server_port
        end

        def start_server
          @start_server == nil ? true : @start_server
        end

        def capture_browser
          @capture_browser == nil ? false : @capture_browser
        end

        def default_server_port
          begin
            conf = File.read(jstd_config_path)
            conf.match(/server:.*:(\d+)$/)[1]
          rescue
            '4224'
          end
        end

        def jar_path
          path = File.join(jar_home, 'jstest*.jar')
          files = Dir.glob(File.expand_path(path), File::FNM_CASEFOLD)
          if files.empty?
            alert = "\e[31mGuard::Jstd could not find your JsTestDriver.jar file. "
            alert << "Please specify it in the configuration.\e[0m"
            UI.info(alert, :reset => true)
            exit
          else
            files.first
          end
        end

        def jar_home
          return @jar_home if @jar_home
          echo = `echo $JSTESTDRIVER_HOME`
          @jar_home = echo == "" ? '~/bin' : echo.gsub!("\n", "")
        end
      end
    end
  end
end
