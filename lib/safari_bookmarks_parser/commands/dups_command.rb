# frozen_string_literal: true

require 'json'
require 'optparse'
require 'yaml'

module SafariBookmarksParser
  module Commands
    class DupsCommand
      attr_reader :plist_path, :output_path, :output_format, :exclude_reading_list

      def initialize(argv)
        @plist_path = File.expand_path('~/Library/Safari/Bookmarks.plist')
        @output_path = nil
        @output_format = :json
        @exclude_reading_list = false

        parse_options(argv)
        handle_argv(argv)
      end

      def run
        plist_parser = Parser.parse(@plist_path)

        bookmarks = bookmarks_to_process(plist_parser).to_a

        duplicated_bookmarks = Services::FindDuplicatedBookmarks.call(bookmarks: bookmarks)

        return if duplicated_bookmarks.empty?

        text = format_result(duplicated_bookmarks)

        output_text(text)
      end

      private

      def bookmarks_to_process(plist_parser)
        if @exclude_reading_list
          plist_parser.root_folder_without_reading_list
        else
          plist_parser.root_folder
        end
      end

      def format_result(bookmark_groups)
        bookmark_groups = bookmark_groups.map do |bookmarks|
          bookmarks.map(&:to_h)
        end

        case @output_format
        when :json
          JSON.pretty_generate(bookmark_groups)
        when :yaml
          YAML.dump(bookmark_groups)
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

        parser.banner = "Usage: #{parser.program_name} dups [options] [~/Library/Safari/Bookmarks.plist]"

        on_output_path(parser)
        on_output_format(parser)
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

      def on_exclude_reading_list(parser)
        parser.on('-R', "Exclude reading list (default: #{@exclude_reading_list})") do
          @exclude_reading_list = true
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

      Runner.register_command(:dups, self)
    end
  end
end
