# frozen_string_literal: true

RSpec.describe SafariBookmarksParser::Commands::DumpCommand do
  let(:command) { described_class.new(argv) }

  context 'when no options and arguments were given' do
    let(:argv) { [] }

    describe '#plist_path' do
      it 'returns ~/Library/Safari/Bookmarks.plist' do
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

    describe '#output_style' do
      it 'returns :tree' do
        expect(command.output_style).to eq(:tree)
      end
    end

    describe '#output_parts' do
      it 'returns :all' do
        expect(command.output_parts).to eq(:all)
      end
    end
  end

  context 'when an invalid option was given' do
    let(:argv) { %w[--foo] }

    it 'raises an error' do
      expect { command }.to raise_error(SafariBookmarksParser::Error, 'invalid option: --foo')
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

    describe '#run' do
      it 'outputs JSON from given path' do
        expect { command.run }.to output(/"title": /).to_stdout
      end
    end
  end

  context 'when -o option was given with "output.json"' do
    let(:argv) { %w[-o output.json] }

    describe '#output_path' do
      it 'returns "output.json"' do
        expect(command.output_path).to eq('output.json')
      end
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

  context 'when --tree option was given' do
    let(:argv) { %w[--tree] }

    describe '#output_style' do
      it 'returns :tree' do
        expect(command.output_style).to eq(:tree)
      end
    end
  end

  context 'when --list option was given' do
    let(:argv) { %w[--list] }

    describe '#output_style' do
      it 'returns :list' do
        expect(command.output_style).to eq(:list)
      end
    end
  end

  describe 'when -r option was given' do
    let(:argv) { %w[-r] }

    describe '#output_parts' do
      it 'returns :reading_list' do
        expect(command.output_parts).to eq(:reading_list)
      end
    end
  end

  describe 'when -R option was given' do
    let(:argv) { %w[-R] }

    describe '#output_parts' do
      it 'returns :bookmarks' do
        expect(command.output_parts).to eq(:bookmarks)
      end
    end
  end
end
