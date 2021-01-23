# frozen_string_literal: true

require 'json'
require 'optparse'
require 'yaml'

module SafariBookmarksParser
  module Commands
    class BaseCommand
      attr_reader :plist_path, :output_path, :output_format

      def initialize(argv)
        @plist_path = File.expand_path('~/Library/Safari/Bookmarks.plist')
        @output_path = nil
        @output_format = :json

        parse_options(argv)
        handle_argv(argv)
      end

      private

      def format_to_text(obj)
        case @output_format
        when :json
          JSON.pretty_generate(obj)
        when :yaml
          YAML.dump(obj)
        end
      end

      def output_text(text)
        if @output_path
          File.write(@output_path, text)
        else
          puts text
        end
      end

      def on_output_path(parser)
        parser.on('-o', '--output-path=PATH', 'Output path (default: output to $stdout)') do |value|
          @output_path = value
        end
      end

      def on_output_format(parser)
        desc = %(Output format (default: "#{@output_format}"; one of "json" or "yaml"))
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
    end
  end
end
