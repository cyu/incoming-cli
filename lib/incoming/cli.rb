require "thor"

original_verbosity = $VERBOSE
$VERBOSE = nil
require 'command_line_reporter'
$VERBOSE = original_verbosity

require "incoming/cli/version"
require "incoming/cli/config"
require "incoming/cli/helper"
require "incoming/cli/inpoint"

module Incoming
  module Cli

    class Main < Thor
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
      def login
        email = ask "email: "
        password = ask "password: ", echo: false

        client_options = {email_and_password: { username: email, password: password }}
        if Cli.config.url_options
          client_options[:url_options] = Cli.config.url_options.dup
        end
        client = Incoming::Client.new(client_options)
        response = client.create_session
        if token = response.body['jwt']
          Cli.config.token = token
          Cli.write_config
          say "\nLogin successful"
        end
      end

      desc "inpoint SUBCOMMAND ...ARGS", "manage inpoint"
      subcommand "inpoint", Inpoint
    end

  end
end
