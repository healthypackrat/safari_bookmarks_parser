# frozen_string_literal: true

module SafariBookmarksParser
  module Services
    class FindDuplicatedBookmarks
      def self.call(bookmarks:)
        cache = Hash.new {|hash, key| hash[key] = [] }

        bookmarks.to_a.each do |bookmark|
          key = bookmark.url.sub(%r{\Ahttps?://}, '')
          cache[key] << bookmark
        end

        cache.select {|_, value| value.size > 1 }.values
      end
    end
  end
end
