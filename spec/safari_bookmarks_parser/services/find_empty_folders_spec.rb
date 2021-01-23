# frozen_string_literal: true

RSpec.describe SafariBookmarksParser::Services::FindEmptyFolders do
  let(:empty_folder1) do
    SafariBookmarksParser::BookmarkFolder.new(title: 'Empty 1', children: [])
  end

  let(:empty_folder2) do
    SafariBookmarksParser::BookmarkFolder.new(title: 'Empty 2', children: [])
  end

  let(:bookmark1) do
    SafariBookmarksParser::Bookmark.new(
      url: 'https://www.ruby-lang.org/en/',
      title: 'Ruby Programming Language',
      folder_names: ['Ruby']
    )
  end

  let(:non_empty_folder1) do
    SafariBookmarksParser::BookmarkFolder.new(title: 'Non-Empty 1', children: [bookmark1, empty_folder1])
  end

  let(:root_folder) do
    SafariBookmarksParser::BookmarkFolder.new(title: 'Root', children: [non_empty_folder1, empty_folder2])
  end

  describe '#call' do
    let(:results) { described_class.call(root_folder: root_folder) }

    it 'returns empty folders' do
      expect(results.size).to be(2)
    end
  end
end
