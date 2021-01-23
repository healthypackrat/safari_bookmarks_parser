# frozen_string_literal: true

require 'json'
require 'optparse'
require 'yaml'

module SafariBookmarksParser
  module Commands
    class DumpCommand
      attr_reader :plist_path, :output_path, :output_format, :output_style, :output_parts

      def initialize(argv)
        @plist_path = File.expand_path('~/Library/Safari/Bookmarks.plist')
        @output_path = nil
        @output_format = :json
        @output_style = :tree
        @output_parts = :all

        parse_options(argv)
        handle_argv(argv)
      end

      def run
        plist_parser = Parser.parse(@plist_path)

        result = result_for_output_parts(plist_parser)
        result = result_for_output_style(result)

        text = format_result(result)

        output_text(text)
      end

      private

      def result_for_output_parts(plist_parser)
        case @output_parts
        when :all
          plist_parser.root_folder
        when :bookmarks
          plist_parser.root_folder_without_reading_list
        when :reading_list
          plist_parser.reading_list
        end
      end

      def result_for_output_style(result)
        case @output_style
        when :tree
          result.to_h
        when :list
          result.to_a.map(&:to_h)
        end
      end

      def format_result(result)
        case @output_format
        when :json
          JSON.pretty_generate(result)
        when :yaml
          YAML.dump(result)
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

        parser.banner = "Usage: #{parser.program_name} dump [options] [~/Library/Safari/Bookmarks.plist]"

        on_output_path(parser)
        on_output_format(parser)

        on_tree(parser)
        on_list(parser)

        on_reading_list_only(parser)
        on_exclude_reading_list(parser)

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

      def on_tree(parser)
        parser.on('--tree', 'Output as tree (default)') do
          @output_style = :tree
        end
      end

      def on_list(parser)
        parser.on('--list', 'Output as list') do
          @output_style = :list
        end
      end

      def on_reading_list_only(parser)
        parser.on('-r', 'Output reading list only') do
          @output_parts = :reading_list
        end
      end

      def on_exclude_reading_list(parser)
        parser.on('-R', 'Exclude reading list') do
          @output_parts = :bookmarks
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

      Runner.register_command(:dump, self)
    end
  end
end
