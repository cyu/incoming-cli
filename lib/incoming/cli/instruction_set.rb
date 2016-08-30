require 'json'

module Incoming
  module Cli

    class InstructionSet < Thor
      include Helper
      include CommandLineReporter

      default_command(:list)

      desc "", "list all instruction sets"
      method_option :profile, type: :string, aliases: '-p'
      def list
        instruction_sets = incoming_client.get_instruction_sets.body
        names = instruction_sets.map { |s| s['name'] }
        table border: false do
          row header: true do
            column 'NAME', width: calculate_width(names, 'NAME')
            column 'CREATED', width: 23
          end
          instruction_sets.each do |instruction_set|
            row do
              column instruction_set['name']
              column instruction_set['created_at']
            end
          end
        end
      end

      desc "info NAME", "show information on an instruction set"
      method_option :profile, type: :string, aliases: '-p'
      method_option :inputs, type: :boolean
      def info(name)
        display_flags = [ :overview, :inputs, :content ]

        if options[:inputs]
          display_flags = [ :inputs ]
        end

        instruction_set = incoming_client.get_instruction_set(name: name).body

        if display_flags.include?  :overview
          puts_attributes(instruction_set, *%w(id name created_at))
        end

        if display_flags.include?(:inputs) && inputs = instruction_set['inputs']
          vertical_spacing 1
          header title: "INPUTS", bold: true
          inputs.each do |input|
            puts "#{input['key']}"
          end
        end

        if display_flags.include?(:content) && content = instruction_set['content']
          vertical_spacing 1
          header title: "INSTRUCTIONS", bold: true
          puts JSON.pretty_generate(content)
        end
      end

    end
    
  end
end


