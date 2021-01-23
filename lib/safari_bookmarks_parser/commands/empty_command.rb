# frozen_string_literal: true

module SafariBookmarksParser
  module Commands
    class EmptyCommand < BaseCommand
      def run
        plist_parser = Parser.parse(@plist_path)

        empty_folders = Services::FindEmptyFolders.call(root_folder: plist_parser.root_folder)

        return if empty_folders.empty?

        text = format_to_text(empty_folders.map(&:to_h))

        output_text(text)
      end

      private

      def parse_options(argv)
        parser = OptionParser.new

        parser.banner = "Usage: #{parser.program_name} empty [options] [~/Library/Safari/Bookmarks.plist]"

        on_output_path(parser)
        on_output_format(parser)

        do_parse(parser, argv)
      end

      Runner.register_command(:empty, self)
    end
  end
end
