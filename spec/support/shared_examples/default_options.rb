# frozen_string_literal: true

RSpec.shared_examples 'default options' do
  describe '#plist_path' do
    it 'returns "~/Library/Safari/Bookmarks.plist"' do
      expect(command.plist_path).to eq(File.expand_path('~/Library/Safari/Bookmarks.plist'))
    end
  end

  describe '#output_path' do
    it 'returns nil' do
      expect(command.output_path).to be_nil
    end
  end

  describe '#output_format' do
    it 'returns :json' do
      expect(command.output_format).to eq(:json)
    end
  end
end
