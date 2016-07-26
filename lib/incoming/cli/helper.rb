require 'logger'
require "incoming"

module Incoming
  module Cli

    class ClientProxy < SimpleDelegator

      def initialize(helper, profile)
        super(helper.create_incoming_client)
        @_helper = helper
        @_profile = profile
      end

      def _extend_session
        response = __getobj__.extend_session
        if response.status == 200
          @_profile.token = response.body['jwt']
          Cli.write_config
          __setobj__(@_helper.create_incoming_client)
        end
        response
      end

      def method_missing(m, *args, &block)
        r = super
        if r.respond_to?(:status) && r.status == 401
          puts 'extending session...'
          extend_response = _extend_session
          if extend_response.status == 200
            r = super
          end
        end
        r
      end

    end

    module Helper

      def set_profile
        @current_profile = if name = options[:profile]
          Cli.config.profiles[name.to_sym]
        else
          Cli.config.default_profile
        end
      end

      def current_profile
        @current_profile ||= begin
          if name = options[:profile]
            Cli.config.profiles[name.to_sym]
          else
            Cli.config.default_profile
          end
        end
      end

      def incoming_client
        @incoming_client ||= ClientProxy.new(self, current_profile)
      end

      def create_incoming_client(auth = nil)
        client_opts = auth || { auth_token: current_profile.token } 
        url_options = current_profile.to_url_options
        unless url_options.empty?
          client_opts[:url_options] = url_options
        end
        puts client_opts
        client = Incoming::Client.new(client_opts)
        puts current_profile.debug
        if current_profile.debug
          logger = Logger.new(STDOUT)
          logger.level = Logger::DEBUG
          client.logger = logger
        end
        client
      end

      def calculate_width(strings, label = '')
        strings.map { |s| s ? s.length : 0 }.concat([label.length]).max
      end

    end

  end
end
