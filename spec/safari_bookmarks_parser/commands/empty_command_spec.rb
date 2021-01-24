# frozen_string_literal: true

require 'tmpdir'

RSpec.describe SafariBookmarksParser::Commands::EmptyCommand do
  let(:command) { described_class.new(argv) }

  context 'when no options and arguments were given' do
    let(:argv) { [] }

    include_examples 'default options'
  end

  context 'when an argument was given' do
    let(:plist_path) { 'spec/fixtures/empty-folders/Bookmarks.plist' }

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

      it 'outputs 3 empty folders' do
        folders = JSON.parse(File.read(output_path))
        expect(folders.size).to eq(3)
      end
    end
  end

  include_context 'common options'
end
