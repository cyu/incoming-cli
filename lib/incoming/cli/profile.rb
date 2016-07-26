module Incoming
  module Cli

    class Profile < Thor
      include Helper
      include CommandLineReporter

      default_command(:list)

      desc "", "list all profiles"
      def list
        profiles = Cli.config.profiles
        table border: false do
          row header: true do
            column 'PROFILE', width: calculate_width(profiles.keys, 'PROFILE')
          end

          profiles.each_pair do |key, _|
            row do
              column key
            end
          end
        end
      end

      desc "new NAME", "Create a new profile"
      method_option :host, type: :string
      method_option :scheme, type: :string
      def new(name)
        profile = Configuration::Profile.new
        if options[:host]
          profile.host = options[:host]
        end
        if options[:scheme]
          profile.scheme = options[:scheme]
        end
        Cli.config.profiles[name.to_sym] = profile
        Cli.write_config
      end

    end

  end
end


