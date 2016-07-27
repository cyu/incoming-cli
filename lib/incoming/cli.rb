require "thor"

original_verbosity = $VERBOSE
$VERBOSE = nil
require 'command_line_reporter'
$VERBOSE = original_verbosity

require "incoming/cli/version"
require "incoming/cli/config"
require "incoming/cli/helper"
require "incoming/cli/inpoint"
require "incoming/cli/account"
require "incoming/cli/profile"
require "incoming/cli/instruction_set"

module Incoming
  module Cli

    class Main < Thor
      include Helper

      desc "hello NAME", "This will greet you"
      long_desc <<-HELLO_WORLD

      `hello NAME` will print out a message to the person of your choosing.

      Brian Kernighan actually wrote the first "Hello, World!" program 
      as part of the documentation for the BCPL programming language 
      developed by Martin Richards. BCPL was used while C was being 
      developed at Bell Labs a few years before the publication of 
      Kernighan and Ritchie's C book in 1972.

      http://stackoverflow.com/a/12785204
      HELLO_WORLD
      option :upcase
      def hello( name  )
        greeting = "Hello, #{name}"
        greeting.upcase! if options[:upcase]
        puts greeting
      end

      desc 'login', 'Login to incominghq.com'
      method_option :profile, type: :string, aliases: '-p'
      def login
        email = ask "email: "
        password = ask "password: ", echo: false

        auth = {email_and_password: { username: email, password: password }}
        client = create_incoming_client(auth)
        response = client.create_session
        if token = response.body['jwt']
          current_profile.token = token
          Cli.write_config
          say "\nLogin successful"
        end
      end

      desc "inpoint SUBCOMMAND ...ARGS", "manage inpoints"
      subcommand "inpoint", Inpoint

      desc "account SUBCOMMAND ...ARGS", "manage accounts"
      subcommand "account", Account

      desc "instruction_set SUBCOMMAND ...ARGS", "manage instruction sets"
      subcommand "instruction_set", InstructionSet

      desc "profile SUBCOMMAND ...ARGS", "manage profiles"
      subcommand "profile", Profile
    end

  end
end
