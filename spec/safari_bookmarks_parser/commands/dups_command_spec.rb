# frozen_string_literal: true

RSpec.describe SafariBookmarksParser::Commands::DupsCommand do
  let(:command) { described_class.new(argv) }

  context 'when no options and arguments were given' do
    let(:argv) { [] }

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

    describe '#exclude_reading_list' do
      it 'returns false' do
        expect(command.exclude_reading_list).to eq(false)
      end
    end
  end

  context 'when -o option was given with "output.json"' do
    let(:argv) { %w[-o output.json] }

    it 'returns "output.json"' do
      expect(command.output_path).to eq('output.json')
    end
  end

  context 'when -f option was given with "json"' do
    let(:argv) { %w[-f json] }

    describe '#output_format' do
      it 'returns :json' do
        expect(command.output_format).to eq(:json)
      end
    end
  end

  context 'when -f option was given with "yaml"' do
    let(:argv) { %w[-f yaml] }

    describe '#output_format' do
      it 'returns :yaml' do
        expect(command.output_format).to eq(:yaml)
      end
    end
  end

  context 'when -R option was given' do
    let(:argv) { %w[-R] }

    describe '#exclude_reading_list' do
      it 'returns true' do
        expect(command.exclude_reading_list).to eq(true)
      end
    end
  end

  context 'when an argument was given' do
    let(:plist_path) { 'spec/fixtures/non-empty/Bookmarks.plist' }
    let(:argv) { [plist_path] }

    describe '#plist_path' do
      it 'returns given plist path' do
        expect(command.plist_path).to eq(plist_path)
      end
    end
  end
end
