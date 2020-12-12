# frozen_string_literal: true

require 'safari_bookmarks_parser/bookmark'
require 'safari_bookmarks_parser/bookmark_folder'

require 'safari_bookmarks_parser/parser'

require 'safari_bookmarks_parser/runner'

require 'safari_bookmarks_parser/commands/dump_command'

require 'safari_bookmarks_parser/version'

module SafariBookmarksParser
  class Error < StandardError; end
end
