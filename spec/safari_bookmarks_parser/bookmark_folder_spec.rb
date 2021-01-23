# frozen_string_literal: true

RSpec.describe SafariBookmarksParser::BookmarkFolder do
  let(:bookmark1) do
    SafariBookmarksParser::Bookmark.new(
      url: 'https://git-scm.com',
      title: 'Git',
      folder_names: ['Development']
    )
  end

  let(:bookmark2) do
    SafariBookmarksParser::Bookmark.new(
      url: 'https://www.zsh.org',
      title: 'Zsh',
      folder_names: ['Development']
    )
  end

  let(:bookmark3) do
    SafariBookmarksParser::Bookmark.new(
      url: 'https://www.ruby-lang.org/en/',
      title: 'Ruby Programming Language',
      folder_names: %w[Development Ruby]
    )
  end

  let(:sub_folder) do
    described_class.new(
      title: 'Ruby',
      folder_names: %w[Development],
      children: [bookmark3]
    )
  end

  let(:folder) do
    described_class.new(
      title: 'Development',
      folder_names: [],
      children: [sub_folder, bookmark1, bookmark2]
    )
  end

  let(:empty_folder) do
    described_class.new(title: 'Empty', folder_names: [])
  end

  describe '#empty?' do
    context 'when given an empty folder' do
      it 'returns true' do
        expect(empty_folder).to be_empty
      end
    end

    context 'when given a non-empty folder' do
      it 'returns false' do
        expect(folder).not_to be_empty
      end
    end
  end

  describe '#to_a' do
    context 'when given an empty folder' do
      it 'returns no bookmarks' do
        expect(empty_folder.to_a).to be_empty
      end
    end

    context 'when given a non-empty folder' do
      it 'returns 3 bookmarks' do
        expect(folder.to_a.size).to eq(3)
      end

      it 'returns ordered bookmarks' do
        expect(folder.to_a).to eq([bookmark3, bookmark1, bookmark2])
      end
    end
  end

  describe '#to_h' do
    context 'when given an empty folder' do
      it 'returns a hash with an empty children' do
        expect(empty_folder.to_h).to eq({ 'title' => 'Empty', 'folder_names' => [], 'children' => [] })
      end
    end

    context 'when given a non-empty folder' do
      it 'returns a hash' do
        expect(folder.to_h).to eq(
          {
            'title' => 'Development',
            'folder_names' => [],
            'children' => [
              {
                'title' => 'Ruby',
                'folder_names' => %w[Development],
                'children' => [
                  {
                    'url' => 'https://www.ruby-lang.org/en/',
                    'title' => 'Ruby Programming Language',
                    'folder_names' => %w[
                      Development
                      Ruby
                    ]
                  }
                ]
              },
              {
                'url' => 'https://git-scm.com',
                'title' => 'Git',
                'folder_names' => [
                  'Development'
                ]
              },
              {
                'url' => 'https://www.zsh.org',
                'title' => 'Zsh',
                'folder_names' => [
                  'Development'
                ]
              }
            ]
          }
        )
      end
    end
  end
end
