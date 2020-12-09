# frozen_string_literal: true

module SafariBookmarksParser
  class BookmarkFolder
    attr_reader :title, :children

    def initialize(title:, children: [])
      @title = title
      @children = children
    end

    def empty?
      to_a.empty?
    end

    def to_a
      results = []
      traverse(self, results)
      results
    end

    def to_h
      { 'title' => title, 'children' => children.map(&:to_h) }
    end

    def to_json(options)
      to_h.to_json(options)
    end

    private

    def traverse(node, results)
      case node
      when BookmarkFolder
        node.children.each do |child|
          traverse(child, results)
        end
      when Bookmark
        results << node
      end
    end
  end
end
