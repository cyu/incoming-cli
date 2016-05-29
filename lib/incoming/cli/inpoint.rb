module Incoming
  module Cli

    class Inpoint < Thor
      include Helper
      include CommandLineReporter

      default_command(:list)

      desc "", "list all inpoints"
      def list
        table border: false do
          row header: true do
            column 'ID', width: 36
            column 'NAME', width: 30
            column 'CREATED', width: 23
          end
          incoming_client.get_inpoints.body.each do |inpoint|
            row do
              column inpoint['id']
              column inpoint['name']
              column inpoint['created_at']
            end
          end
        end
      end
    end
    
  end
end

