# frozen_string_literal: true

require 'tmpdir'

RSpec.describe SafariBookmarksParser::Commands::DupsCommand do
  let(:command) { described_class.new(argv) }

  context 'when no options and arguments were given' do
    let(:argv) { [] }

    include_examples 'default options'

    describe '#exclude_reading_list' do
      it 'returns false' do
        expect(command.exclude_reading_list).to eq(false)
      end
    end
  end

  context 'when an argument was given' do
    let(:plist_path) { 'spec/fixtures/dups/Bookmarks.plist' }

    describe '#plist_path' do
      let(:argv) { [plist_path] }

      it 'returns given plist path' do
        expect(command.plist_path).to eq(plist_path)
      end
    end

    describe '#run' do
      let(:output_path) { File.join(Dir.tmpdir, 'Bookmarks.json') }
      let(:argv) { ['-o', output_path, plist_path] }

      before do
        command.run
      end

      it 'outputs 2 duplicated bookmark groups' do
        groups = JSON.parse(File.read(output_path))
        expect(groups.size).to eq(2)
      end
    end
  end

  include_context 'common options'

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
