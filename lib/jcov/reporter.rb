module JCov

  class Reporter

    def self.report coverage_data
      coverage_data.each do |filename, data|

        unless data.empty?
          puts filename
          content = IO.readlines(filename)
          content.each_with_index do |line, i|
            puts "#{data[i+1]} :: #{line}"
          end
        end

      end
    end

  end

end
