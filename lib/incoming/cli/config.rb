require "yaml"
require "ostruct"

module Incoming
  module Cli

    def self.config_file
      File.join(ENV['HOME'], '.incominghq')
    end

    def self.config
      @config ||= begin
        if File.exist?(config_file)
          OpenStruct.new(YAML.load(File.read(config_file)))
        else
          OpenStruct.new
        end
      end
    end

    def self.write_config
      File.open(config_file, 'w') { |f| f.write(YAML.dump(config.to_h)) }
    end

  end
end
