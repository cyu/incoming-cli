require "yaml"
require "ostruct"

module Incoming
  module Cli

    class Configuration

      attr_accessor :default_profile, :profiles

      class Profile
        attr_accessor :host, :scheme, :token, :debug

        def to_h
          h = {}
          h[:host] = host if host
          h[:scheme] = scheme if scheme
          h[:token] = token if token
          h[:debug] = debug if debug
          h
        end

        def to_url_options
          h = to_h
          h.delete(:token)
          h
        end

        def self.from_hash(h)
          profile = new
          profile.host = h[:host]
          profile.scheme = h[:scheme]
          profile.token = h[:token]
          profile.debug = h[:debug]
          profile
        end
      end

      def initialize
        @default_profile = Configuration::Profile.new
        @profiles = {}
      end

      def get_profile(name)
        profiles[name.to_sym]
      end

      def to_h
        h = default_profile.to_h
        h[:profiles] = Hash[profiles.map { |(k,v)| [k,v.to_h] }]
        h
      end

      def self.from_hash(hash)
        profiles = {}

        if hash[:profiles]
          profiles = Hash[hash[:profiles].map { |(k,v)| [k,Configuration::Profile.from_hash(v)] }]
        end

        hash = hash.dup
        hash.delete(:profiles)

        config = Configuration.new
        config.default_profile = Configuration::Profile.from_hash(hash)
        config.profiles = profiles
        config
      end
    end

    def self.config_file
      File.join(ENV['HOME'], '.incominghq')
    end

    def self.config
      @config ||= begin
        if File.exist?(config_file)
          h = YAML.load(File.read(config_file))
          Configuration.from_hash(h)
        else
          Configuration.new
        end
      end
    end

    def self.write_config
      File.open(config_file, 'w') { |f| f.write(YAML.dump(config.to_h)) }
    end

  end
end
