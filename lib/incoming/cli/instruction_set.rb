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

      desc "show NAME", "show a instruction set"
      method_option :profile, type: :string, aliases: '-p'
      def show(name)
        instruction_set = incoming_client.get_instruction_set(name: name).body
        table border: false do
          keys = %w(name created_at)
          name_width = calculate_width(keys)
          value_width = calculate_width(keys.map { |k| instruction_set[k].to_s })
          keys.each do |key|
            row do
              column key.upcase.gsub('_', ' '), width: name_width, bold: true
              column instruction_set[key], width: value_width
            end
          end
        end

        if inputs = instruction_set['inputs']
          vertical_spacing 2
          header title: "INPUTS", bold: true
          puts JSON.pretty_generate(inputs)
        end

        if content = instruction_set['content']
          vertical_spacing 2
          header title: "INSTRUCTIONS", bold: true
          puts JSON.pretty_generate(content)
        end
      end

    end
    
  end
end


