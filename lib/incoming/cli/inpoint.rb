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

      desc "show NAME", "show information on a particular inpoint"
      def show(name)
        result = incoming_client.get_inpoint(name: name).body
        table border: false do
          keys = %w(id name created_at last_execution_on execution_count failed_execution_count aborted_execution_count instruction_set)
          keys.each do |key|
            row do
              column key.upcase.gsub('_', ' '), width: calculate_width(keys), bold: true
              column result[key], width: 100
            end
          end
        end
        if result["inputs"] && result["inputs"].length > 0
          vertical_spacing 2
          header title: "INPUTS"
          table border: false do
            row header: true do
              column 'NAME', width: calculate_width(result["inputs"].map { |i| i['key'] }, 'NAME')
              column 'DEFAULT', width: calculate_width(result["inputs"].map { |i| i['default'] }, 'DEFAULT')
            end

            result["inputs"].each do |input|
              row do
                column input['key']
                column input['default']
              end
            end
          end
        end
      end

    end
    
  end
end

