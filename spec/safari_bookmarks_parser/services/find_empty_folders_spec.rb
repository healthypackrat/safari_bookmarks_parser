# frozen_string_literal: true

RSpec.describe SafariBookmarksParser::Services::FindEmptyFolders do
  let(:empty_folder1) do
    SafariBookmarksParser::BookmarkFolder.new(
      title: 'Rails',
      folder_names: %w[Root Ruby],
      children: []
    )
  end

  let(:empty_folder2) do
    SafariBookmarksParser::BookmarkFolder.new(
      title: 'JavaScript',
      folder_names: %w[Root],
      children: []
    )
  end

  let(:bookmark1) do
    SafariBookmarksParser::Bookmark.new(
      url: 'https://www.ruby-lang.org/en/',
      title: 'Ruby Programming Language',
      folder_names: %w[Root Ruby]
    )
  end

  let(:non_empty_folder1) do
    SafariBookmarksParser::BookmarkFolder.new(
      title: 'Ruby',
      folder_names: %w[Root],
      children: [bookmark1, empty_folder1]
    )
  end

  let(:root_folder) do
    SafariBookmarksParser::BookmarkFolder.new(
      title: 'Root',
      folder_names: [],
      children: [non_empty_folder1, empty_folder2]
    )
  end

  describe '#call' do
    let(:results) { described_class.call(root_folder: root_folder) }

    it 'returns empty folders' do
      expect(results.size).to be(2)
    end
  end
end
