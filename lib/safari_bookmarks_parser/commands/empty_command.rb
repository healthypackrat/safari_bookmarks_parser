# frozen_string_literal: true

require 'json'
require 'optparse'
require 'yaml'

module SafariBookmarksParser
  module Commands
    class EmptyCommand
      attr_reader :plist_path, :output_path, :output_format

      def initialize(argv)
        @plist_path = File.expand_path('~/Library/Safari/Bookmarks.plist')
        @output_path = nil
        @output_format = :json

        parse_options(argv)
        handle_argv(argv)
      end

      def run
        plist_parser = Parser.parse(@plist_path)

        results = Services::FindEmptyFolders.call(root_folder: plist_parser.root_folder)

        return if results.empty?

        text = format_results(results)

        output_text(text)
      end

      private

      def format_results(results)
        results = results.map(&:to_h)

        case @output_format
        when :json
          JSON.pretty_generate(results)
        when :yaml
          YAML.dump(results)
        end
      end

      def output_text(text)
        if @output_path
          File.write(@output_path, text)
        else
          puts text
        end
      end

      def parse_options(argv)
        parser = OptionParser.new

        parser.banner = "Usage: #{parser.program_name} empty [options] [~/Library/Safari/Bookmarks.plist]"

        on_output_path(parser)
        on_output_format(parser)

        do_parse(parser, argv)
      end

      def on_output_path(parser)
        parser.on('-o', '--output-path=PATH', 'Output path (default: output to $stdout)') do |value|
          @output_path = value
        end
      end

      def on_output_format(parser)
        desc = "Output format (default: #{@output_format}; one of json or yaml)"
        parser.on('-f', '--output-format=FORMAT', %w[json yaml], desc) do |value|
          @output_format = value.to_sym
        end
      end

      def do_parse(parser, argv)
        parser.parse!(argv)
      rescue OptionParser::ParseError => e
        raise Error, e.message
      end

      def handle_argv(argv)
        @plist_path = argv.first if argv.any?
      end

      Runner.register_command(:empty, self)
    end
  end
end
