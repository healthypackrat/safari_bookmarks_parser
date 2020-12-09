# frozen_string_literal: true

RSpec.describe SafariBookmarksParser::Parser do
  context 'empty bookmarks' do
    let(:parser) { described_class.parse(fixture_path('empty/Bookmarks.plist')) }

    describe '#root_folder' do
      it "doesn't return any bookmarks and reading list items" do
        expect(parser.root_folder).to be_empty
      end
    end

    describe '#root_folder_without_reading_list' do
      it "doesn't return any bookmarks" do
        expect(parser.root_folder_without_reading_list).to be_empty
      end
    end

    describe '#reading_list' do
      it "doesn't return reading list" do
        expect(parser.reading_list).to be_nil
      end
    end
  end

  context 'non-empty bookmarks' do
    let(:parser) { described_class.parse(fixture_path('non-empty/Bookmarks.plist')) }

    describe '#root_folder' do
      it 'returns 17 bookmarks and reading list items' do
        expect(parser.root_folder.to_a.size).to eq(17)
      end
    end

    describe '#root_folder_without_reading_list' do
      it 'returns 14 bookmarks' do
        expect(parser.root_folder_without_reading_list.to_a.size).to eq(14)
      end
    end

    describe '#reading_list' do
      it 'returns 3 reading list items' do
        expect(parser.reading_list.to_a.size).to eq(3)
      end
    end
  end
end
