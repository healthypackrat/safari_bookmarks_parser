# frozen_string_literal: true

require 'English'
require 'tempfile'

module SafariBookmarksParser
  def self.parse(binary_plist_path)
    Parser.parse(binary_plist_path)
  end

  class Parser
    READING_LIST_KEY = 'com.apple.ReadingList'

    def self.parse(binary_plist_path)
      new.parse(binary_plist_path)
    end

    attr_reader :root_folder, :root_folder_without_reading_list, :reading_list

    def initialize
      @root_folder = nil
      @root_folder_without_reading_list = nil
      @reading_list = nil
    end

    def parse(binary_plist_path)
      root_node = parse_xml_plist(binary_plist_to_xml_plist(binary_plist_path))

      parse_combined(root_node)
      parse_splitted(root_node)

      self
    end

    private

    def parse_combined(root_node)
      @root_folder = traverse(root_node)
    end

    def parse_splitted(root_node)
      root_folder = traverse(root_node)

      index = root_folder.children.find_index {|child| child.title == READING_LIST_KEY }
      @reading_list = root_folder.children.delete_at(index) if index

      @root_folder_without_reading_list = root_folder
    end

    def traverse(node, folder_names = [])
      case node.fetch('WebBookmarkType')
      when 'WebBookmarkTypeList'
        accept_list(node, folder_names)
      when 'WebBookmarkTypeLeaf'
        accept_leaf(node, folder_names)
      end
    end

    def accept_list(node, folder_names)
      title = node.fetch('Title')

      children = node.fetch('Children', []).map do |child|
        traverse(child, folder_names + [title])
      end.compact

      BookmarkFolder.new(title: title, children: children)
    end

    def accept_leaf(node, folder_names)
      url = node.fetch('URLString')
      title = node.fetch('URIDictionary').fetch('title')

      Bookmark.new(url: url, title: title, folder_names: folder_names)
    end

    def parse_xml_plist(xml_plist)
      Plist.parse_xml(xml_plist)
    end

    def binary_plist_to_xml_plist(binary_plist_path)
      Tempfile.open(['Bookmarks', '.xml']) do |tempfile|
        command = ['plutil', '-convert', 'xml1', '-o', tempfile.path, binary_plist_path]

        raise Error, "plutil returned #{$CHILD_STATUS.exitstatus}" unless system(*command)

        tempfile.read
      end
    end
  end
end
