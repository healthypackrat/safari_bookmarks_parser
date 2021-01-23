# frozen_string_literal: true

module SafariBookmarksParser
  module Commands
    class DumpCommand < BaseCommand
      attr_reader :output_style, :output_parts

      def initialize(argv)
        @output_style = :tree
        @output_parts = :all

        super
      end

      def run
        plist_parser = Parser.parse(@plist_path)

        result = select_output_parts(plist_parser)
        result = select_output_style(result)

        text = format_to_text(result)

        output_text(text)
      end

      private

      def select_output_parts(plist_parser)
        case @output_parts
        when :all
          plist_parser.root_folder
        when :bookmarks
          plist_parser.root_folder_without_reading_list
        when :reading_list
          plist_parser.reading_list
        end
      end

      def select_output_style(result)
        case @output_style
        when :tree
          result.to_h
        when :list
          result.to_a.map(&:to_h)
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

      Runner.register_command(:dump, self)
    end
  end
end
