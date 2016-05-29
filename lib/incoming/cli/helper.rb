require "incoming"

module Incoming
  module Cli

    class ClientProxy < SimpleDelegator

      def initialize(helper)
        super(helper.create_incoming_client)
        @_helper = helper
      end

      def _extend_session
        response = __getobj__.extend_session
        if response.status == 200
          Cli.config.token = response.body['jwt']
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

      def incoming_client
        @incoming_client ||= ClientProxy.new(self)
      end

      def create_incoming_client
        client_opts = { auth_token: Cli.config.token } 
        if Cli.config.url_options
          client_opts[:url_options] = Cli.config.url_options.dup
        end
        Incoming::Client.new(client_opts)
      end

    end

  end
end
