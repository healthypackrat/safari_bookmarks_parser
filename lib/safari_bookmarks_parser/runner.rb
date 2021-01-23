# frozen_string_literal: true

require 'optparse'

module SafariBookmarksParser
  class Runner
    class << self
      def known_commands
        @known_commands ||= {}
      end

      def register_command(command_name, command_class)
        known_commands[command_name.to_sym] = command_class
      end
    end

    def initialize(argv)
      @argv = argv.dup

      @parser = nil

      parse_options(@argv)
    end

    def run
      command_name = @argv.shift

      if command_name
        command_class = self.class.known_commands[command_name.to_sym]

        raise Error, "unknown command: #{command_name}" unless command_class

        command_class.new(@argv).run
      else
        show_help(@parser)
      end
    end

    private

    def show_help(parser)
      puts parser
      puts
      puts <<~MESSAGE
        Available commands are:

          - dump
          - dups
      MESSAGE
    end

    def parse_options(argv)
      parser = OptionParser.new

      parser.banner = "Usage: #{parser.program_name} [options] command"

      parser.version = VERSION

      on_show_help(parser)
      on_show_version(parser)

      do_parse(parser, argv)

      @parser = parser
    end

    def on_show_help(parser)
      parser.on('-h', '--help', 'Show this message') do
        show_help(parser)
        exit
      end
    end

    def on_show_version(parser)
      parser.on('-v', '--version', 'Show version number') do
        puts "#{parser.program_name} #{VERSION}"
        exit
      end
    end

    def do_parse(parser, argv)
      parser.order!(argv)
    rescue OptionParser::ParseError => e
      raise Error, e.message
    end
  end
end
