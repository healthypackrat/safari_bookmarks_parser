# frozen_string_literal: true

RSpec.describe SafariBookmarksParser::Bookmark do
  let(:bookmark) do
    described_class.new(
      url: 'https://www.ruby-lang.org/en/',
      title: 'Ruby Programming Language',
      folder_names: %w[Development Ruby]
    )
  end

  describe '#to_h' do
    it 'converts to a hash' do
      expect(bookmark.to_h).to eq(
        'url' => 'https://www.ruby-lang.org/en/',
        'title' => 'Ruby Programming Language',
        'folder_names' => %w[Development Ruby]
      )
    end
  end
end
