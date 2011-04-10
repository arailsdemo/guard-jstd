module Guard
  class Jstd
    module CaseFinder
      def self.find(paths)
        paths.collect do |path|
          contents = File.read(path)
          contents.scan(/TestCase\s*\(\s*["']([^"']+)/)
        end.flatten.uniq.join(',')
      end
    end
  end
end
