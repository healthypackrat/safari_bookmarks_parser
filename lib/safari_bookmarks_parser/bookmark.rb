# frozen_string_literal: true

module SafariBookmarksParser
  class Bookmark
    attr_reader :url, :title, :folder_names

    def initialize(url:, title:, folder_names:)
      @url = url
      @title = title
      @folder_names = folder_names
    end

    def to_h
      { 'url' => url, 'title' => title, 'folder_names' => folder_names }
    end

    def to_json(options)
      to_h.to_json(options)
    end
  end
end
