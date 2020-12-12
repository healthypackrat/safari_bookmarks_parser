# frozen_string_literal: true

RSpec.describe SafariBookmarksParser::Runner do
  let(:runner) { described_class.new(argv) }

  describe '#run' do
    context "when a command name wasn't given" do
      let(:argv) { %w[] }

      it 'shows help' do
        expect { runner.run }.to output(/Usage: /).to_stdout
      end
    end

    context 'when an unknown command name was given' do
      let(:argv) { %w[foo] }

      it 'raises an error' do
        expect { runner.run }.to raise_error(SafariBookmarksParser::Error, 'unknown command: foo')
      end
    end

    context 'when a known command name was given' do
      let(:argv) { %w[bar] }

      before do
        command_instance = double('command instance', run: nil)
        command_class = double('command class')
        allow(command_class).to receive(:new).and_return(command_instance)
        described_class.register_command(:bar, command_class)
      end

      it "doesn't raise an error" do
        expect { runner.run }.not_to raise_error
      end
    end
  end

  describe '.register_command' do
    let(:command_class) { double('command class') }

    before do
      described_class.register_command(:baz, command_class)
    end

    it 'has a command' do
      expect(described_class.known_commands[:baz]).to eq(command_class)
    end
  end
end
