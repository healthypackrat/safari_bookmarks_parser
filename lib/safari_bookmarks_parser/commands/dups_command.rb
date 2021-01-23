# frozen_string_literal: true

module SafariBookmarksParser
  module Commands
    class DupsCommand < BaseCommand
      attr_reader :exclude_reading_list

      def initialize(argv)
        @exclude_reading_list = false

        super
      end

      def run
        plist_parser = Parser.parse(@plist_path)

        bookmarks = bookmarks_to_process(plist_parser).to_a

        duplicated_bookmark_groups = Services::FindDuplicatedBookmarks.call(bookmarks: bookmarks)

        return if duplicated_bookmark_groups.empty?

        duplicated_bookmark_groups = duplicated_bookmark_groups.map do |group|
          group.map(&:to_h)
        end

        text = format_to_text(duplicated_bookmark_groups)

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

      def parse_options(argv)
        parser = OptionParser.new

        parser.banner = "Usage: #{parser.program_name} dups [options] [~/Library/Safari/Bookmarks.plist]"

        on_output_path(parser)
        on_output_format(parser)

        on_exclude_reading_list(parser)

        do_parse(parser, argv)
      end

      def on_exclude_reading_list(parser)
        parser.on('-R', "Exclude reading list (default: #{@exclude_reading_list})") do
          @exclude_reading_list = true
        end
      end

      Runner.register_command(:dups, self)
    end
  end
end
