module Incoming
  module Cli

    class Account < Thor
      include Helper
      include CommandLineReporter

      default_command(:list)

      desc "", "list all accounts"
      def list
        table border: false do
          row header: true do
            column 'ID', width: 36
            column 'NAME', width: 30
            column 'CREATED', width: 23
          end
          incoming_client.get_authentication_accounts.body.each do |account|
            row do
              column account['id']
              column account['name']
              column account['created_at']
            end
          end
        end
      end
    end
    
  end
end

