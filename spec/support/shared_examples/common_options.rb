# frozen_string_literal: true

RSpec.shared_context 'common options' do
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
end
