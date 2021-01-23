# frozen_string_literal: true

RSpec.describe SafariBookmarksParser::Services::FindDuplicatedBookmarks do
  let(:bookmark1) do
    SafariBookmarksParser::Bookmark.new(
      url: 'https://www.ruby-lang.org/en/',
      title: 'Ruby Programming Language',
      folder_names: ['Ruby']
    )
  end

  let(:bookmark2) do
    SafariBookmarksParser::Bookmark.new(
      url: 'https://rubyonrails.org',
      title: 'Ruby on Rails',
      folder_names: ['Rails']
    )
  end

  let(:bookmark3) do
    SafariBookmarksParser::Bookmark.new(
      url: 'https://rubygems.org',
      title: 'RubyGems.org',
      folder_names: ['Ruby']
    )
  end

  let(:bookmark4) do
    SafariBookmarksParser::Bookmark.new(
      url: 'https://www.ruby-lang.org/en/',
      title: 'Ruby Programming Language',
      folder_names: %w[Development Ruby]
    )
  end

  let(:bookmark5) do
    SafariBookmarksParser::Bookmark.new(
      url: 'https://rubyonrails.org',
      title: 'Ruby on Rails',
      folder_names: %w[Development Rails]
    )
  end

  context 'when duplicated bookmarks exist' do
    let(:bookmarks) { [bookmark1, bookmark2, bookmark3, bookmark4, bookmark5] }

    it 'returns a list of duplicated bookmarks' do
      expect(described_class.call(bookmarks: bookmarks)).to eq([[bookmark1, bookmark4], [bookmark2, bookmark5]])
    end
  end

  context "when duplicated bookmarks don't exist" do
    let(:bookmarks) { [bookmark1, bookmark2, bookmark3] }

    it 'returns an empty array' do
      expect(described_class.call(bookmarks: bookmarks)).to eq([])
    end
  end
end
