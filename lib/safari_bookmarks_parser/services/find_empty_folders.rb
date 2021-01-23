# frozen_string_literal: true

module SafariBookmarksParser
  module Services
    class FindEmptyFolders
      class << self
        def call(root_folder:)
          results = []

          traverse(root_folder, results)

          results
        end

        def traverse(node, results)
          case node
          when BookmarkFolder
            if node.children.empty?
              results << node
            else
              node.children.each do |child|
                traverse(child, results)
              end
            end
          end
        end
      end
    end
  end
end
