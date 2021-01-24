# frozen_string_literal: true

RSpec.describe SafariBookmarksParser::Commands::DumpCommand do
  let(:command) { described_class.new(argv) }

  context 'when no options and arguments were given' do
    let(:argv) { [] }

    include_examples 'default options'

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

  include_context 'common options'

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
