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

      desc "info NAME", "show information about particular inpoint"
      def info(name)
        result = incoming_client.get_inpoint(name: name).body
        puts_attributes result, *%w(id name created_at last_execution_on execution_count failed_execution_count aborted_execution_count instruction_set)
        if result["inputs"] && result["inputs"].length > 0
          puts ''
          puts 'INPUTS'
          result["inputs"].each do |input|
            puts "#{input['key']}"
          end
        end
      end

    end
    
  end
end

